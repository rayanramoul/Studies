flex Lexique.l && bison -d Syntaxe.y && gcc lex.yy.c Syntaxe.tab.c -ly -o Compilateur
