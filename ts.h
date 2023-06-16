#ifndef TS_H
#define TS_H


typedef struct
{
    int state;
    char name[20];
    char code[20];
    char type[20];
    float val;
    float is_cst;

    char valCh[20];
} element;

element tab[1000];

typedef struct
{
    int state;
    char name[20];
    char type[20];
} elt;



elt tabs[40], tabm[40];
extern char sav[20];
char chaine [] = "";



void initialisation();
void inserer (char entite[], char code[], char type[], float val, int i, int y,float c);
void rechercher (char entite[], char code[], char type[], float val,int y);
void afficher();
int Recherche_position(char entite[]);
int doubleDeclaration(char entite[]);
int CompatibleType(char type[], char type1[]);
char* GetType(char entite[]);
char* GetCode(char entite[]);
float GetValue(char entite[]);
int GetConst(char entite[]);
void insererTYPE(char entite[], char type[]);
void insererCODE(char entite[], char code[]);
void insertValEntiere(char entite[], int val);
void insertReal(char entite[], float val);
void insertCST(char entite[], float x);
void insertCh(char entite[], char val[]);

#endif