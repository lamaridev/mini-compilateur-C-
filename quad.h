#ifndef QUAD_H
#define QUAD_H

//t la taille de la table contenant les quadruplets
#define t 1000
//la structure d'un element de la table 

typedef struct 
{
    char* opr;
    char* op1;
    char* op2;
    char* res;
}quadruplet;

// pile pour resresenter les element de la pile .. un poiteur vers la donnee et un poiteur vers lelement precedent 

typedef struct element_pile{
	char *donnee;
	struct element_pile *prc;
}pile;



// pile pour mettre ajour la position du qc (pour les branchemnt ) le int represente la position de la donne et 
//poiteur vers lelemnt precedant 



typedef struct element_pile_Qc{
	int donnee;
	struct element_pile_Qc *prc;
}pileQc;

pileQc *pile1;





//declaration de la table 
quadruplet q[t];

//signature des fonctions de qud.c
void quad(char*,char*,char*,char*);
void afficherQuad();

void createQuadCompare(int type, char *cond1, char *cond2, char *res);

//convert interger to string
char* ToSTR(int i);

void empiler_qc(pileQc **p, int pos);
int depiler_qc(pileQc **p);

#endif //QUAD_H
