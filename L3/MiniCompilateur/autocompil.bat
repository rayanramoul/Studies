flex lex.l
bison -d synt.y
gcc lex.yy.c synt.tab.c -lfl -ly -o compilateur.exe
pause