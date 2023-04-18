#!/bin/sh

bison -d projlang.y 
flex projlang.l 
gcc -o projlang projlang.tab.c lex.yy.c -lfl
