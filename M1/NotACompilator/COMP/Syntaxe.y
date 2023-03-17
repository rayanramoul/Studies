%{
#include<string.h>
#include <stdio.h>
#include <stdlib.h>
#include "Quad.h"
FILE* yyin;
int yylex();
typedef int bool;
char tmp[20],tmp2[20],tmp3[20],tmp5[20],tmp4[20],tmp6[20],tmp7[20],tmp8[20],tmp9[20],tmp10[20];
int sauv_cond=0,sauv_inst=0,sauv_fin;
extern int t; // Compteur des états temporaires
int l=1,n=0; // Compteurs pour les bounds
int op_count=0; // Compteur du nombre d'operandes pour chaque operation
enum { false, true };
	extern int found(char nom[]);
	extern void insert(char nom[], char code[],int nbrl,int nbrc,int taille,int val, char type[]);
	extern void show();
	extern int retournerVal(char nom[]);
extern void insereTaille(char nom[], int taille);
extern int doubleDeclaration (char nom[]);
extern void insereType(char nom[],char type[]);
extern void yyerror(char *s);
int prems=0;
char sauvOper[20] ;
char sauvType[20];
 char    sauvIDF[20];
bool sauvCond;
int sauvExp,sauvProd;
//extern Pile *initialiser();
int dixit=0; // Compteur du nombre d'accolades qui se sont ouvertes.
int dixit_if=0;
int dixit_while=0;

int nbr_if=0;
int nbr_while=0;
int addr_if[200],addr_while[200]; // addresses au fur et à mesure de chacune de ces accolades.
int i=0;
int j;
int nbrligne;
int nbrcolonne;
%}


%union {
int entier;
float reel;
char* str;
char car;
   }
%token mc_Algo mc_Deb mc_If mc_Execut mc_while mc_CONST bibl_tab bibl_boucle bibl_calcul SEP '{' '}' <str>mc_INT <str>mc_REAL <str>IDF OPREL AFF PLUS SUST MULT DIV '(' ')' ';' '[' ']' '+' '-' <entier>CONST_ENT <reel>CONST_REAL <str>String

%%

Programme:BIBL mc_Algo IDF  DEC '{' INST_Plus '}' {printf("\n***********************************Programme syntaxiquement correct*********************************\n");YYACCEPT;}
;
BIBL:                       bibl_tab BIBL
                       |bibl_boucle BIBL
                           |bibl_calcul BIBL
	                       |
;
IDF_Plus: IDF SEP IDF_Plus {
                          if ( doubleDeclaration($1)==1){insereType($1,sauvType);insereTaille($1,1);}
                          else {printf("\nErreur Sémantique: double declation de %s, a la ligne %d\n", $1, nbrligne);}}
          |IDF {
		                  if ( doubleDeclaration($1)==1){insereType($1,sauvType);insereTaille($1,1);}
                          else {printf("\nErreur Sémantique: double declation de %s, a la ligne %d\n", $1, nbrligne);}}

;
DEC_Simp:TYPE IDF_Plus ';'
;

IDF_Plus_Tab:IDF '[' CONST_ENT ']' SEP IDF_Plus_Tab
                 {

			     if($3 <=0){printf("\nErreur Semantique: taille de %s est negative ou nulle , a la ligne %d\n", $1, nbrligne);}
				 else{ insereTaille($1,$3);}
			    if ( doubleDeclaration($1)==1){insereType($1,sauvType);sprintf(tmp10,"L%d",l);sprintf(tmp9,"%d",$3);quadr("BOUNDS",tmp10,tmp9,"");quadr("ADEC",$1,"","");
                         } else {printf("\nErreur Semantique: double declation de %s, a la ligne %d\n", $1, nbrligne);}
						 }
          | IDF '[' CONST_ENT ']'
		  {

			     if($3 <=0){printf("\nErreur Semantique: taille de %s est negative ou nulle , a la ligne %d\n", $1, nbrligne);}
				 else{ insereTaille($1,$3);}
			    if ( doubleDeclaration($1)==1){insereType($1,sauvType);insereType($1,sauvType);sprintf(tmp10,"L%d",l);sprintf(tmp9,"%d",$3);quadr("BOUNDS",tmp10,tmp9,"");quadr("ADEC",$1,"","");
                         } else {printf("\nErreur Semantique: double declation de %s, a la ligne %d\n", $1, nbrligne);}
						 }
;
DEC_Tab: TYPE IDF_Plus_Tab ';'
;

DEC: DEC_Simp DEC
     | DEC_Tab DEC
	 |
;
// ------------------- Boucle ------------------
INST_Boucle:  mc_while'(' C COND_WHILE ')'
             '{'
             INST_Plus
             '}'
			 D
            { if(found("#BOUCLE")!=-1){printf("\nErreur Semantique: la bibliotheque Tab est manquante , a la ligne %d.\n", nbrligne);}
				}
;
C: {addr_while[dixit_while]=taille+1;dixit_while++;}
;
D:{sprintf(tmp,"Quadr N°%d",taille+2);ajour_quad(addr_while[dixit_while-1],2,tmp);sprintf(tmp,"Quadr N°%d",addr_while[dixit_while-1]);dixit_while--;quadr("BR",tmp,"","");}
;
COND_WHILE:IDF OPREL IDF   {if(strcmp($2,"==")==0){strcpy(tmp,"BNE");}if (strcmp($2,"<")==0) strcpy(tmp,"BGE");if (strcmp($2,">")==0) strcpy(tmp,"BLE");if (strcmp($2,"<=")==0) strcpy(tmp,"BG");if (strcmp($2,">=")==0) strcpy(tmp,"BL");if (strcmp($2,"!=")==0) strcpy(tmp,"BE"); quadr(tmp,"JUMP",$1,$2);}
      | IDF OPREL CONST_ENT {if(strcmp($2,"==")==0){strcpy(tmp,"BNE");}if (strcmp($2,"<")==0) strcpy(tmp,"BGE");if (strcmp($2,">")==0) strcpy(tmp,"BLE");if (strcmp($2,"<=")==0) strcpy(tmp,"BG");if (strcmp($2,">=")==0) strcpy(tmp,"BL");if (strcmp($2,"!=")==0) strcpy(tmp,"BE"); sprintf(tmp7,"%d",$3);quadr(tmp,"JUMP",$1,tmp7);}
	  | IDF OPREL CONST_REAL {if(strcmp($2,"==")==0){strcpy(tmp,"BNE");}if (strcmp($2,"<")==0) strcpy(tmp,"BGE");if (strcmp($2,">")==0) strcpy(tmp,"BLE");if (strcmp($2,"<=")==0) strcpy(tmp,"BG");if (strcmp($2,">=")==0) strcpy(tmp,"BL");if (strcmp($2,"!=")==0) strcpy(tmp,"BE");sprintf(tmp7,"%f",$3);quadr(tmp,"JUMP",$1,tmp7);}
;
// ------------------- Condition ------------------
INST_Cond: mc_Execut A
           INST_Plus
		   mc_If '(' COND_IF ')' B
;
A: {quadr("BR","","","");addr_if[dixit_if]=taille+1;dixit_if++;}
;
B:{sprintf(tmp8,"Quadr N°%d",addr_if[dixit_if-1]);ajour_quad(taille,2,tmp8);sprintf(tmp8,"Quadr N°%d",taille);ajour_quad(addr_if[dixit_if-1]-1,2,tmp8);dixit_if--;}
;
COND_IF: IDF OPREL IDF   {if(strcmp($2,"==")==0){strcpy(tmp,"BE");}if (strcmp($2,"<")==0) strcpy(tmp,"BL");if (strcmp($2,">")==0) strcpy(tmp,"BG");if (strcmp($2,"<=")==0) strcpy(tmp,"BLE");if (strcmp($2,">=")==0) strcpy(tmp,"BGE");if (strcmp($2,"!=")==0) strcpy(tmp,"BNE");sprintf(tmp9,"Quadr N°%d",taille+3);quadr("BR",tmp9,"",""); ;quadr(tmp,"JUMP",$1,$2);}
      | IDF OPREL CONST_ENT {if(strcmp($2,"==")==0){strcpy(tmp,"BE");}if (strcmp($2,"<")==0) strcpy(tmp,"BL");if (strcmp($2,">")==0) strcpy(tmp,"BG");if (strcmp($2,"<=")==0) strcpy(tmp,"BLE");if (strcmp($2,">=")==0) strcpy(tmp,"BGE");if (strcmp($2,"!=")==0) strcpy(tmp,"BNE"); sprintf(tmp9,"Quadr N°%d",taille+3);quadr("BR",tmp9,"","");sprintf(tmp7,"%d",$3);quadr(tmp,"JUMP",$1,tmp7);}
	  | IDF OPREL CONST_REAL {if(strcmp($2,"==")==0){strcpy(tmp,"BE");}if (strcmp($2,"<")==0) strcpy(tmp,"BL");if (strcmp($2,">")==0) strcpy(tmp,"BG");if (strcmp($2,"<=")==0) strcpy(tmp,"BLE");if (strcmp($2,">=")==0) strcpy(tmp,"BGE");if (strcmp($2,"!=")==0) strcpy(tmp,"BNE");sprintf(tmp9,"Quadr N°%d",taille+3);quadr("BR",tmp9,"","");sprintf(tmp7,"%f",$3);quadr(tmp,"JUMP",$1,tmp7);}
;


// ------------------- Instruction ------------------
INST: EPIC INST_Aff
     | INST_Cond
	 | INST_Boucle
;
INST_Plus: INST INST_Plus
          |INST
;
INST_Aff:
         IDF AFF expres ';' {sprintf(tmp2,"T%d",t-1),quadr(":=",tmp2,"",$1);t++;}
		 |IDF AFF CONST_ENT ';'{sprintf(tmp2,"%d",$3);quadr(":=",tmp2,"",$1);}
		 |IDF AFF IDF ';'		 {quadr(":=",$3,"",$1);}
		 |IDF AFF CONST_REAL ';'{sprintf(tmp2,"%f",$3);quadr(":=",tmp2,"",$1);}
		 |IDF '[' CONST_ENT ']' AFF expres ';'{sprintf(tmp2,"T%d",t-1);sprintf(tmp10,"%s[%d]",$1,$3);quadr(":=",tmp2,"",tmp10);}
		 |IDF '[' CONST_ENT ']' AFF CONST_ENT ';'{sprintf(tmp2,"%d",$6);sprintf(tmp10,"%s[%d]",$1,$3);quadr(":=",tmp2,"",tmp10);}
		 |IDF '[' CONST_ENT ']' AFF CONST_REAL ';'{sprintf(tmp2,"%f",$6);sprintf(tmp10,"%s[%d]",$1,$3);quadr(":=",tmp2,"",tmp10);}
		 |IDF '[' CONST_ENT ']' AFF IDF ';'		 {sprintf(tmp10,"%s[%d]",$1,$3);quadr(":=",$6,"",tmp10);}
;
EPIC: {op_count=taille+1;}
;
expres: CONST_ENT PLUS prod {sprintf(tmp3,"T%d",t);sprintf(tmp5,"%d",$1);quadr("+",tmp5,tmp4,tmp3);t++;}
		| CONST_REAL PLUS prod {sprintf(tmp3,"T%d",t);sprintf(tmp5,"%f",$1);quadr("+",tmp5,tmp4,tmp3);t++;}
		| IDF PLUS prod  {sprintf(tmp3,"T%d",t);quadr("+",$1,tmp4,tmp3);t++;}
        | IDF SUST prod		 {sprintf(tmp3,"T%d",t);quadr("-",$1,tmp4,tmp3);t++;}
		| IDF '[' CONST_ENT ']' PLUS prod  {sprintf(tmp3,"T%d",t);sprintf(tmp10,"%s[%d]",$1,$3);quadr("+",tmp10,tmp4,tmp3);t++;}
        | IDF '[' CONST_ENT ']' SUST prod	{sprintf(tmp3,"T%d",t);sprintf(tmp10,"%s[%d]",$1,$3);quadr("-",tmp10,tmp4,tmp3);t++;}
        | CONST_ENT SUST prod {sprintf(tmp3,"T%d",t);sprintf(tmp5,"%d",$1);quadr("-",tmp5,tmp4,tmp3);t++;}
        | CONST_REAL SUST prod {sprintf(tmp3,"T%d",t);sprintf(tmp5,"%f",$1);quadr("+",tmp5,tmp4,tmp3);t++;}
		| IDF {sprintf(tmp4,"%s",$1);}
		| CONST_ENT{sprintf(tmp4,"%d",$1);}
		| CONST_REAL{sprintf(tmp4,"%f",$1)}
		| IDF '[' CONST_ENT ']' {sprintf(tmp4,"%s[%d]",$1,$3);}
		| prod
;
prod: CONST_ENT MULT expres {sprintf(tmp3,"T%d",t);sprintf(tmp5,"%d",$1);epic_quadr(op_count,"*",tmp5,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
		| CONST_REAL MULT expres {sprintf(tmp3,"T%d",t);sprintf(tmp5,"%f",$1);epic_quadr(op_count,"*",tmp5,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
		| IDF MULT expres {sprintf(tmp3,"T%d",t);sprintf(tmp6,"T%d",t);epic_quadr(op_count,"*",$1,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
        | IDF DIV expres		{sprintf(tmp3,"T%d",t);sprintf(tmp6,"%d",t);epic_quadr(op_count,"/",$1,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
		|  IDF '[' CONST_ENT ']' MULT expres {sprintf(tmp3,"T%d",t);sprintf(tmp6,"T%d",t);sprintf(tmp10,"%s[%d]",$1,$3);epic_quadr(op_count,"*",tmp10,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
        |  IDF '[' CONST_ENT ']' DIV expres		{sprintf(tmp3,"T%d",t);sprintf(tmp6,"%d",t);sprintf(tmp10,"%s[%d]",$1,$3);epic_quadr(op_count,"/",tmp10,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
        | CONST_ENT DIV expres{sprintf(tmp3,"T%d",t);sprintf(tmp6,"%d",$1);epic_quadr(op_count,"/",tmp6,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
        | CONST_REAL DIV expres{sprintf(tmp3,"T%d",t);sprintf(tmp6,"%f",$1);epic_quadr(op_count,"/",tmp6,tmp4,tmp3);t++;strcpy(tmp4,tmp3);}
		| IDF {sprintf(tmp4,"%s",$1);}
		| IDF '[' CONST_ENT ']' {sprintf(tmp4,"%s[%d]",$1,$3);}
		| CONST_ENT {sprintf(tmp4,"%d",$1);}
		| CONST_REAL {sprintf(tmp4,"%f",$1);}
	    | expres
;
operateur:PLUS {strcpy(sauvOper,$1);}
         |SUST {strcpy(sauvOper,$1);}
         |MULT {strcpy(sauvOper,$1);}
         |DIV  {strcpy(sauvOper,$1);}
;
TYPE:mc_INT     {strcpy(sauvType,$1);}
    |mc_REAL    {strcpy(sauvType,$1);}
;
CONST: CONST_ENT {strcpy(type,"Integer");}
		   | CONST_REAL {strcpy(type,"Real");}
;

%%


int main()
{

 yyin = fopen("entree.txt", "r");

 yyparse();
 show();
/*
	quadr("A1","B1","C1","D1");
		quadr("A2","B2","C2","D2");
			quadr("A3","B3","C3","D3");
				quadr("A4","B4","C4","D4");
				ajour_quad(2,2,"CHANGED SUCCESSFULLY");*/

 afficherQuadruplets(&pileQuads);
 optimisation();

}

yywrap()
{}
