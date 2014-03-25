#!/bin/sh
#
########################################################################
# Install Python
#  $1 = version
#  $2 = prefix
#  $3 = not save to src
########################################################################

setup_environment() {
    test -n "$2" || PREFIX=/opt/python/$1
    test -n "$2" && PREFIX=$2
    test -n "$3" || SUDO=sudo
    test -n "$3" && SUDO=
    test "$3" = "sudo" && SUDO=sudo
    case $OSTYPE in
      *darwin*)
        OPTIONS=-pR
        OWNER=root:wheel
        ;;
      *)
        OPTIONS=-a
        OWNER=root:root
        ;;
    esac
}

save_sources() {
    test -d /usr/local/src/python || $SUDO mkdir -p /usr/local/src/python
    $SUDO cp $OPTIONS Python-$1 /usr/local/src/python
    $SUDO chown $OWNER /usr/local/src/python
    $SUDO chown -R $OWNER /usr/local/src/python/Python-$1
}

make_and_install() {
    cd Python-$1
    ./configure --prefix $PREFIX
    make
    $SUDO make install
    cd ..
}

get_python() {
    mkdir install_python
    cd install_python
    curl -L http://www.python.org/ftp/python/$1/Python-$1.tgz -O
    test -f Python-$1.tgz || exit 1
    tar xzvf Python-$1.tgz
    test "$2" = "sourceonly" || make_and_install $*
    test -n "$3" || save_sources $*
    cd ..
    $SUDO rm -rf install_python
}

create_symlink() {
    test -x $PREFIX/bin/python3 && test -x $PREFIX/bin/python || $SUDO ln -s $PREFIX/bin/python3 $PREFIX/bin/python
    test -x $PREFIX/bin/ipython3 && test -x $PREFIX/bin/ipython || $SUDO ln -s $PREFIX/bin/ipython3 $PREFIX/bin/ipython
    test -x $PREFIX/bin/pip3 && test -x $PREFIX/bin/pip || $SUDO ln -s $PREFIX/bin/pip3 $PREFIX/bin/pip
}

install_python() {
    setup_environment $*
    test -n "$1" || exit 1
    get_python $*
    create_symlink $*
    python -V
}

ping -c 1 python.org > /dev/null 2>&1 || exit 1
install_python $*
