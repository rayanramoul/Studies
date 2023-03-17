%{
int nb_ligne=1,nb_colonne=1;

#include "synt.tab.h"
#include <stdio.h> 
#include<string.h>
extern YYSTYPE yylval;
%}

lettre [a-zA-Z]
chiffre [0-9]
idf {lettre}({lettre}|{chiffre})*
constReel {chiffre}+"."{chiffre}+
constEntier [0-9]*
constChaine \"([^\"]*)*\" 

%%
stop yyterminate();

ALGORITHME {nb_colonne+=yyleng;return mc_ALGORITHME;}
entier {yylval.chaine=strdup(yytext);nb_colonne+=yyleng; return mc_entier;}
reel  {yylval.chaine=strdup(yytext);nb_colonne+=yyleng; return mc_reel;  }
chaine {yylval.chaine=strdup(yytext);nb_colonne+=yyleng; return mc_chaine;}

VAR {nb_colonne+=yyleng;return mc_VAR;}
DEBUT {nb_colonne+=yyleng; return mc_DEBUT;}
FIN {nb_colonne+=yyleng; return mc_FIN; }

Pour {nb_colonne+=yyleng; return mc_Pour; }
jusque {nb_colonne+=yyleng; return mc_jusque;}
Faire {nb_colonne+=yyleng; return mc_Faire;}
Fait {nb_colonne+=yyleng; return mc_Fait;}
SI {nb_colonne+=yyleng; return mc_SI; }

"<--" {nb_colonne+=yyleng;return op_AFF; }
!=|=|<|>|<=|>= {yylval.chaine=strdup(yytext);nb_colonne+=yyleng; return op_comp;}
[+*-/] {yylval.chaine=strdup(yytext); nb_colonne+=yyleng;
		return op_arith; }
\| {nb_colonne+=yyleng; return bar;}


{idf} {if (yyleng >12) printf ("erreur , il faut moins de 12 car") ;
        else {yylval.chaine=strdup(yytext);	nb_colonne+=yyleng; return identificateur;}}
		
{constEntier} {yylval.entier=atoi(yytext); nb_colonne+=yyleng; return const_entier;}
{constReel} {yylval.reel=atof(yytext); nb_colonne+=yyleng; return const_reel;}
{constChaine} {yylval.chaine=strdup(yytext); nb_colonne+=yyleng; return const_chaine;}
	
"(" {nb_colonne+=yyleng; return parenthese_gauche;}
")" {nb_colonne+=yyleng; return parenthese_droite;}
"/*"([^*]*("*"+[^*/])*)*"*"+"/" {nb_colonne+=yyleng;}
"//"(.)* 

[ \t] nb_colonne+=yyleng;
\n {nb_ligne++;nb_colonne=1;}
: {nb_colonne+=yyleng; return dp;}
; {nb_colonne+=yyleng; return pvg;}
"[" {nb_colonne+=yyleng; return crochet_gauche;}
"]" {nb_colonne+=yyleng; return crochet_droit;}

. printf("erreur lexicale a la ligne %d colonne %d\n",nb_ligne,nb_colonne) ;

%%
int yywrap()
{ return 1;}


