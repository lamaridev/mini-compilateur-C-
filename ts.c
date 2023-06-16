#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "ts.h"


void initialisation()
{
    int i;
    for (i=0; i<25; i++){
        tab[i].state= 0;
        strcpy(tab[i].type, chaine);
    }
    for (i=0; i<40; i++){
        tabs[i].state= 0;
        tabm[i].state= 0;
    }
}


void inserer (char entite[], char code[], char type[], float val, int i, int y,float c)
{
    switch (y)
    {
        case 0:
            tab[i].state= 1;
            strcpy(tab[i].name, entite);
            strcpy(tab[i].code, code);
            strcpy(tab[i].type, type);
            tab[i].val=val;
            tab[i].is_cst=c;
            break;

        case 1:
            tabm[i].state=1;
            strcpy(tabm[i].name, entite);
            strcpy(tabm[i].type, code);
            break;

        case 2:
            tabs[i].state= 1;
            strcpy(tabs[i].name, entite);
            strcpy(tabs[i].type, code);
            break;
    }
}


void rechercher (char entite[], char code[], char type[], float val,int y)
{
    int i;
    switch(y)
    {
        case 0:
            for (i=0; ((i<1000)&&(tab[i].state==1)) && (strcmp(entite,tab[i].name)!=0); i++);
            if((i<1000) && (strcmp(entite,tab[i].name)!=0)) inserer(entite,code,type,val,i,0,0);
            break;
        case 1:
            for (i=0;((i<40)&&(tabm[i].state==1)) && (strcmp(entite,tabm[i].name)!=0);i++);
            if(i<40 && (strcmp(entite,tabm[i].name)!=0))
            inserer(entite,code,type,val,i,1,0);
            break;
        case 2:
            for (i=0;((i<40)&&(tabs[i].state==1)) && (strcmp(entite,tabs[i].name)!=0);i++);
            if(i<40 && (strcmp(entite,tabs[i].name)!=0))
            inserer(entite,code,type,val,i,2,0);
            break;
    }
}

void afficher(){
    int i=0;
    printf("/******************************************************* Table des symboles IDF ************************************************************************************/\n");
    printf("______________________________________________________________________________________________________________________________________________________________________\n");
    printf("\t|              Name              |              Code              |              Type              |              Val              |              Cst              |\n");
    printf("_____________________________________________________________________________________________________________________________________________________________________\n");

    while(tab[i].state == 1){
        printf("\t| %30s | %30s | %30s |                      %0f |            %0f \n",tab[i].name,tab[i].code,tab[i].type,tab[i].val,tab[i].is_cst);
        i++;
    }


    printf("\n/************************ Table des symboles mots cles **********************/\n");
    printf("__________________________________________________________________________\n");
    printf("\t|              Name              |              Code              \n");
    printf("__________________________________________________________________________\n");

    for(i=0; i<40; i++)
        if(tabm[i].state==1)
        {
            printf("\t| %30s | %30s | \n",tabm[i].name, tabm[i].type);
        }


    printf("\n/************************ Table des symboles separateurs **********************/\n");
    printf("__________________________________________________________________________\n");
    printf("\t|              Name              |              Code              \n");
    printf("__________________________________________________________________________\n");

    for(i=0; i<40; i++)
    if(tabs[i].state==1)
        {
            printf("\t| %30s | %30s | \n",tabs[i].name,tabs[i].type );
        }
}


int Recherche_position(char entite[])
{
    int i=0;
    while(i<1000)
    {
        if (strcmp(entite,tab[i].name)==0) return i;
        i++;
    }
    return -1;
}


int doubleDeclaration(char entite[])
{
    int pos;
    pos= Recherche_position(entite);
    if(strcmp(tab[pos].type,"") == 0) return 0;
    else return 1;
}


int CompatibleType(char type[], char type1[]){
    if(strcmp(type, type1) == 0){return 1;}
    return 0;
}


 char* GetType(char entite[]){
	int pos;
    char x [20];
    
	pos= Recherche_position(entite);
	return(tab[pos].type);

   
}


char* GetCode(char entite[]) {
    int pos;
    char x[20];
    pos = Recherche_position(entite);
    return (tab[pos].code);
}



float GetValue(char entite[]){
	int pos;
	pos= Recherche_position(entite);
	return(tab[pos].val);
}

int GetConst(char entite[])
{
     int pos;
    pos= Recherche_position(entite);
    if(tab[pos].is_cst == 1.0) return 1;
    else return 0;
}

void insererTYPE(char entite[], char type[])
{
    int pos;
    pos = Recherche_position(entite);
    strcpy(tab[pos].type,type);
}


void insererCODE(char entite[], char code[])
{
    int pos;
    pos = Recherche_position(entite);
    strcpy(tab[pos].code,code);
}





void insertValEntiere(char entite[], int val){
	int pos;
    pos= Recherche_position(entite);
	tab[pos].val = val;
}


void insertReal(char entite[], float val){
	int pos;
	pos= Recherche_position(entite);

	tab[pos].val = val;
}


void insertCST(char entite[], float x){
	int pos;
	pos= Recherche_position(entite);

	tab[pos].is_cst = x;
}


void insertCh(char entite[], char val[]){
	   int pos;
	   pos= Recherche_position(entite);
	    strcpy(tab[pos].valCh , val) ;
}

