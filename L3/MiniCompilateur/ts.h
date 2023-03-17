#include<stdio.h>
#include<stdlib.h>
#include<string.h>
//structure de la table de symbole
typedef struct
{
char NomEntite[20];
int TailleEntite;
char TypeEntite[20];
}TypeTS;

TypeTS ts[100];
int CpTabSym=0;


int recherche(char entite[])
{
	int i=0;
	while(i<CpTabSym)
	{
		if (strcmp(entite,ts[i].NomEntite)==0) return i;
		i++;
	}

	return -1;
}

void inserer(char nom[], char type[], int taille)
{

	if ( recherche(nom)==-1)
	{
		strcpy(ts[CpTabSym].NomEntite,nom); 
		ts[CpTabSym].TailleEntite=taille;;
		strcpy(ts[CpTabSym].TypeEntite,type);
		CpTabSym++;
	}
}

void afficher ()
{
	printf("\n/***************Table des symboles ******************/\n");
	printf("________________________\n");
	printf("\t| NomEntite |TypeEntite|TailleEntite \n");
	printf("________________________\n");
	int i=0;
	while(i<CpTabSym)
  	{
    	printf("\t|%10s |%12s  | %d\n",ts[i].NomEntite,ts[i].TypeEntite,ts[i].TailleEntite);
    	i++;
   	}
}
