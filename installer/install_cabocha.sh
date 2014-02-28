#!/bin/sh
#
########################################################################
# Install CaboCha
#  $1 = cabocha version
#  $2 = CRF version
########################################################################

setup_environment() {
    test -n "$1" || CABOCHA_VERSION=0.67
    test -n "$1" && CABOCHA_VERSION=$1
    test -n "$2" || CRF_VERSION=0.58
    test -n "$2" && CRF_VERSION=$1
    case $OSTYPE in
      *darwin*)
        OWNER=root:wheel
        OPTIONS=-pR
        ;;
      *)
        OWNER=root:root
        OPTIONS=-a
        ;;
    esac
}

save_sources() {
    sudo mkdir -p /usr/local/src/cabocha
    sudo cp $OPTIONS cabocha-$CABOCHA_VERSION /usr/local/src/cabocha
    sudo mkdir -p /usr/local/src/CRF
    sudo cp $OPTIONS "CRF++-$CRF_VERSION" /usr/local/src/CRF
    sudo chown -R root:root /usr/local/src/cabocha
}

install_crf() {
    wget http://crfpp.googlecode.com/files/CRF%2B%2B-$CRF_VERSION.tar.gz
    tar xzvf "CRF++-$CRF_VERSION.tar.gz"
    cd "CRF++-$CRF_VERSION"
    ./configure
    make
    sudo make install
    cd ..
}

install_cabocha() {
    wget http://cabocha.googlecode.com/files/cabocha-$CABOCHA_VERSION.tar.bz2
    tar xjvf cabocha-$CABOCHA_VERSION.tar.bz2
    cd cabocha-$CABOCHA_VERSION
    ./configure --with-charset=UTF8 --with-posset=IPA
    make
    sudo make install
}

install_crf_and_cabocha() {
    mkdir install_cabocha
    cd install_cabocha

    install_crf $*
    install_cabocha $*

    cd ..
    test -n "$2" || save_sources
    cd ..
    sudo rm -rf install_cabocha
}

main() {
    setup_environment $*
    install_crf_and_cabocha $*
}

ping -c 1 cabocha.googlecode.com > /dev/null 2>&1 || exit 1
main $*
