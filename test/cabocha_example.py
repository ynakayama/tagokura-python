#!/usr/bin/env python
# -*- coding: utf-8 -*-

import CaboCha
cabocha = CaboCha.Parser('--charset=UTF8')
sent = "太郎はこの本を二郎を見た女性に渡した。"

print("--- print (sent) ---")
print(sent)

print("--- print (cabocha.parseToString(sent)) ---")
print(cabocha.parseToString(sent))

tree = cabocha.parse(sent)

print("-- print (tree.toString(CaboCha.FORMAT_LATTICE)) ---")
print(tree.toString(CaboCha.FORMAT_LATTICE))

print("--- print (tree.toString(CaboCha.FORMAT_XML)) ---")
print(tree.toString(CaboCha.FORMAT_XML))

print("--- print (tree.toString(0)) ---")
print(tree.toString(0))
print("--- print (tree.toString(1)) ---")
print(tree.toString(1))
print("--- print (tree.toString(2)) ---")
print(tree.toString(2))
print("--- print (tree.toString(3)) ---")
print(tree.toString(3))
print("--- print (tree.toString(4)) ---")
print(tree.toString(4))

