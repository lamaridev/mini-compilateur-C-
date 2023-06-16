flex lex_23.l
bison -d  synt.y
gcc lex.yy.c synt.tab.c -lfl -ly -o tp.exe
tp.exe < test2.txt


