%{
#include "Syntaxe.tab.h"
//#include "Syntaxe.tab.c"
#include<string.h>
#include <stdio.h>
#include <stdlib.h>
int nbrligne=1;
int nbrcolonne=1;
int entite = 0;
int qc=0;
	typedef struct {
		char nom[20];
		char code[20];
		char type[20];
		int  nbrl;
		int  nbrc;
		int  taille;
		int val;
		
	} type_TS;

	type_TS TS[100];

int	cpt = 0;

	int found(char nom[]);
	void insert(char nom[], char code[],int nbrl,int nbrc,int taille,int val, char type[]);
	void show();
	extern YYSTYPE yylval;

int found(char nom[]) {
	int i = 0;
	for (i = 0; i < cpt; i++)
		if (strcmp(TS[i].nom, nom) == 0) return i;
	return -1;
}

void insert(char nom[], char code[],int nbrl,int nbrc,int taille,int val, char type[]) {
	if (found(nom) != -1){
	   // printf("\n| %-14s |   Existe deja   | %10d | %10d | %10d | %10d | %10s |",yytext,nbrl,nbrc,0,0,"");
	   // printf("\n|----------------|-----------------|------------|------------|------------|------------|------------|");
		}
	 else {
		strcpy(TS[cpt].nom, nom);
		strcpy(TS[cpt].type, type);
		strcpy(TS[cpt].code, code);
		TS[cpt].nbrc= nbrc;
		TS[cpt].nbrl= nbrl;
		TS[cpt].taille= taille;
		TS[cpt].val=1000;
		cpt++;
	}
}



 void show() {
    printf("\n/**************************************Table des symboles*******************************************/\n");
	printf("\n|----------------|-----------------|------------|------------|------------|------------|------------|");
	printf("\n|   occurence    |       code      |    ligne   |  colonne   |   taille   |   valeur   |    type    |");
	printf("\n|----------------|-----------------|------------|------------|------------|------------|------------|");
	
	int i=0;
  while(i<cpt)
  {

    printf("\n| %-14s | %15s | %10d | %10d | %10d | %10d | %10s |",TS[i].nom,TS[i].code,TS[i].nbrl,TS[i].nbrc,TS[i].taille,TS[i].val,TS[i].type);
    printf("\n|----------------|-----------------|------------|------------|------------|------------|------------|");
    i++;
   }
}
//retourner la valeur d'une entité
 int retournerVal(char nom[])
     {
         int posEntite=found(nom);

           return TS[posEntite].val;
       }
int retournerTaille(char nom[])
     {
         int posEntite=found(nom);

           return TS[posEntite].taille;
       }
  char* retournerType(char nom[])
     {
         int posEntite=found(nom);

           return TS[posEntite].type;
       }
//insérer la valeur d'une entité dans la table de symbole
   void insereVal(char nom[], int val)
        {
            int posEntite=found(nom);
            if (posEntite!=-1) //si l’entité existe
             { 
                TS[posEntite].val=val;

             }
        }

	  

   void insereTaille(char nom[], int taille)
    {
      int posEntite=found(nom);
        if (posEntite!=-1) //si l’entité existe
        { 
           TS[posEntite].taille=taille;

        }
    }
	   void insereType(char nom[],char type[])
    {
      int posEntite=found(nom);
        if (posEntite!=-1) //si l’entité existe
        { 
           strcpy(TS[posEntite].type,type);

        }
    }
   int doubleDeclaration (char nom[])
   {
       int posEntite=found(nom);

          if (strcmp(TS[posEntite].type,"")==0) return 1;// donc elle est pas encore déclarée
           else return 0;            // le type de l'entité existe déjà dans la TS et donc c'est une double déclaration

    }
int yyerror(char *s) 
{
  printf("\n            Erreur Syntaxique !!!!   a la ligne: %d      |     colonne :%d  \n", nbrligne,nbrcolonne);
    return 1;
}





%}
IDF [a-zA-Z][a-zA-Z0-9_]*
Lettre  [A-Za-z]
Chiffre [1-9][0-9]*|0
Sep [_]
cst [1-9][0-9]*|0
CONST_ENT [+-]?{Chiffre}
CONST_REAL [+-]?{Chiffre}[,]{Chiffre}+
Taille [1-9][0-9]*
Symbole {.}*
Comment1 "//"
Comment2 "/*"
String ["][A-Za-z ]+["]
%x IN_COMMENT1
%%


"//"            {	BEGIN(IN_COMMENT1);    	}

 <IN_COMMENT1>{
				 "//"      {BEGIN(INITIAL);}	// finish the comment
				 [^\n]+    					// eat comment
				 \n                         {nbrcolonne=1; nbrligne++;}
				 [^\n]+
				 \/       					// eat the lone /
}

{CONST_ENT}           {yylval.entier=atoi(yytext);nbrcolonne=nbrcolonne+yyleng; entite++;return CONST_ENT;           }
{CONST_REAL}          {yylval.reel=atoi(yytext);nbrcolonne=nbrcolonne+yyleng; entite++;return CONST_REAL;           }

[\[\]();{}]          {nbrcolonne=nbrcolonne+yyleng; entite++;return yytext[0];        }
"||"                   {nbrcolonne=nbrcolonne+yyleng; entite++;return SEP;             }
[\n]                  {nbrligne++; nbrcolonne=1;                                                              }
[ ]+                  {nbrcolonne=nbrcolonne+yyleng;                                                          }
[\t]+                 {nbrcolonne=nbrcolonne+(yyleng*8);                                                      }
"<"                   {nbrcolonne=nbrcolonne+yyleng; entite++;yylval.str=strdup(yytext);return OPREL;             }
">"                   {nbrcolonne=nbrcolonne+yyleng; entite++;yylval.str=strdup(yytext);return OPREL;             }
"<="                  {nbrcolonne=nbrcolonne+yyleng; entite++;yylval.str=strdup(yytext); return OPREL;            }
">="                  {nbrcolonne=nbrcolonne+yyleng; entite++; yylval.str=strdup(yytext); return OPREL;           }
"!="                  {nbrcolonne=nbrcolonne+yyleng; entite++;yylval.str=strdup(yytext);  return OPREL;           }
"=="                  {nbrcolonne=nbrcolonne+yyleng; entite++;yylval.str=strdup(yytext);  return OPREL;           }
":="                 {nbrcolonne=nbrcolonne+yyleng; entite++;return AFF;             }
"+"                   {nbrcolonne=nbrcolonne+yyleng; entite++;return PLUS;               }
"-"                   {nbrcolonne=nbrcolonne+yyleng; entite++;return SUST;           }
"*"                   {nbrcolonne=nbrcolonne+yyleng; entite++;return MULT;         }
"/"                   {nbrcolonne=nbrcolonne+yyleng; entite++;return DIV;                }
ALGORITHME            {nbrcolonne=nbrcolonne+yyleng; entite++;return mc_Algo;            }
CONST               {yylval.str=strdup(yytext); nbrcolonne=nbrcolonne+yyleng; entite++;return mc_CONST;              }
Integer               {yylval.str=strdup(yytext); nbrcolonne=nbrcolonne+yyleng; entite++;return mc_INT;              }
Real                  {yylval.str=strdup(yytext); nbrcolonne=nbrcolonne+yyleng; entite++;return mc_REAL;             }



IF                    {nbrcolonne=nbrcolonne+yyleng; entite++;return mc_If;               }
EXECUT                 {nbrcolonne=nbrcolonne+yyleng; entite++;return mc_Execut;            }
While                  {nbrcolonne=nbrcolonne+yyleng; entite++;return mc_while;             }

#TAB\n                    {yylval.str=strdup(yytext); insert("#TAB", "Bibliotheque" ,nbrligne,nbrcolonne,1,0,"");nbrcolonne=nbrcolonne+yyleng; entite++;return bibl_tab;}
#BOUCLE[ \t]*\n                 {yylval.str=strdup(yytext); insert("#BOUCLE", "Bibliotheque" ,nbrligne,nbrcolonne,1,0,"");nbrcolonne=nbrcolonne+yyleng; entite++;return bibl_boucle;}
#Calcul[ \t]*\n                 {yylval.str=strdup(yytext); insert("#Calcul", "Bibliotheque" ,nbrligne,nbrcolonne,1,0,"");nbrcolonne=nbrcolonne+yyleng; entite++;return bibl_calcul;}

{IDF} {if(yyleng<=12) {yylval.str=strdup(yytext);
                       insert(yytext, "Identificateur" ,nbrligne,nbrcolonne,0,1000,"");nbrcolonne=nbrcolonne+yyleng; entite++; return IDF;}
	   else {printf("\n| %-14s | Erreur 'idf >12'| %10d | %10d | %10d |" ,yytext,nbrligne,nbrcolonne,0,0,"");
                     printf("\n|----------------|-----------------|------------|------------|------------|------------|------------|");}
	  };

. insert(yytext,"Erreur lexicale" ,nbrligne,nbrcolonne,1,0,"");
%%




/*
main ()
{
yylex();
show();
}
*/