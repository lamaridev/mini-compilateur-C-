#include<stdio.h>
#include<string.h>
#include <stdlib.h>
#include "quad.h"


int indq=0;

void quad (char* o,char*o1,char*o2,char*r)
{
    q[indq].opr=o;
    q[indq].op1=o1;
    q[indq].op2=o2;
    q[indq].res=r;
    indq++;
}



void afficherQuad()
{
   
    int i;
    for ( i = 0; i < indq; i++)
    {
        printf("%d-(%s ,%s ,%s ,%s )\n",i,q[i].opr,q[i].op1,q[i].op2,q[i].res);
    }
    
}

//convert interger to string
char* ToSTR(int i){
	char s[15];
	sprintf(s,"%d",i);
	return strdup(s);
}

//creation d'1 quad arithmeitque
void createQuadCompare(int type, char *cond1, char *cond2, char *res){
	char *TypeBR;
	switch(type){
		case 1 :{
			TypeBR=strdup("BNE");
		}
		break;
		case 2 :{
			TypeBR=strdup("BE");
		}
		break;
		case 3 :{
			TypeBR=strdup("BL");
		}
		break;
		case 4 :{
			TypeBR=strdup("BG");
		}
		break;
		case 5 :{
			TypeBR=strdup("BGE");
		}
		break;
		case 6 :{
			TypeBR=strdup("BLE");
		}
		break;
	}
	quad(TypeBR,ToSTR(indq+3),cond1,cond2);
	quad("=","1","",res);
	quad("BR",ToSTR(indq+2),"","");
	quad("=","0","",res);
}

//creation d'1 quad logique
void createQuadLogic(int type, char *cond1, char *cond2, char *res){
	switch(type){
		case 1 :{//1==> not
			quad("BNZ",ToSTR(indq+3),cond1,"");
			quad("=","1","",res);
			quad("BR",ToSTR(indq+2),"","");
			quad("=","0","",res);
		}
		break;
		case 2 :{//2==> or
			quad("BNZ",ToSTR(indq+4),cond1,"");
			quad("BNZ",ToSTR(indq+3),cond2,"");
			quad("=","0","",res);
			quad("BR",ToSTR(indq+2),"","");
			quad("=","1","",res);
		}
		break;
		case 3 :{//3==> and
			quad("BZ",ToSTR(indq+4),cond1,"");
			quad("BZ",ToSTR(indq+3),cond2,"");
			quad("=","1","",res);
			quad("BR",ToSTR(indq+2),"","");
			quad("=","0","",res);
		}
		break;
	}
}  



// empilement 
void empiler_qc(pileQc **p, int pos){
     pileQc *new;
	 new=(pileQc*)malloc(sizeof(pileQc));
	  new->donnee = pos;

	//mise à jour chainage
	new->prc=*p;
	*p=new;
}

// dépilement 

int depiler_qc(pileQc **p){
	int position;
	pileQc *H;
	H=*p;
	position = H->donnee;
	*p= H->prc;
	free(H);
	return position;
	
}