%{

#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
#include "ts.h"
#include "ts.c"
#include "quad.h"
#include "quad.c" 
#include "optimisation.h"
#include "optimisation.c" 
#include "code_obj.c"
#include "code_obj.h"



int yylex();
int yyerror(char *);



extern int nb_ligne, col;

char tabIdf[30][10];
int indice = 0;
char sauvType[25];


char * nom; 
int nTemp=1;
char tempC[12]="";
int else_pos,fin_pos;
int d_for,fin_for;
int d_while,fin_while;

%}

  %union 
  { 
      int ENTIER; 
      float REEL;
      char* STRING;
      struct
      {
        float x ;
        char* y;
        char * chaine;
        

      }model;
      
  }

  
%token INTEGER FLOAT CONST IF ELSE STRUCT WHILE FOR CODE VAR  <STRING>IDF <ENTIER>CST_INT POINTV '[' ']' ADD SOUS MULT DIV DPOINT SUPP commentaire INF SUPPOUEGL INFOUEGL EGL DIFF AND  OR POINT AFF POV PFR AOV AFR VR <REEL>CST_REEL NO 

  %left OR
  %left AND
  %left SUPP SUPPOUEGL EGL DIFF INFOUEGL INF
  %left ADD SOUS
  %left MULT DIV



%type <model> CST LIST_VAR_CONST VARIA  EXPRESSION COND
  


%start S
%%

S: IDF AOV PARTIE_STRUCT VAR AOV  PARTIE_VAR AFR CODE AOV PARTIE_CODE AFR AFR {printf ("\n************ ||  programme syntaxiquement correcte  || ********* \n\n"); YYACCEPT;}
;


/***************************************   Definition Struct ***********************************************/

PARTIE_STRUCT : STRUCT AOV PARTIE_VAR AFR IDF POINTV PARTIE_STRUCT {if(doubleDeclaration($5)==1){printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$5,nb_ligne,col);}
else{insererTYPE($5,"STRUCT");insererCODE($5,"IDF");}}

              | commentaire 
              | 
;              



/***************************************   Partie declaration ***********************************************/

PARTIE_VAR :   SIMPLE_DEC PARTIE_VAR
             | TAB_DEC PARTIE_VAR
             | CONST_DEC PARTIE_VAR
             | STRUCT_DEC PARTIE_VAR
             | commentaire PARTIE_VAR
             | 
;	

/*********************************   Partie SIMPLE DECLARATION ***********************************************/

SIMPLE_DEC : TYPE LIST_VAR POINTV  {int indice2=0;
										 while(indice2<indice)
											{insererTYPE(tabIdf[indice2],sauvType);strcpy(tabIdf[indice2],"");indice2++;}
											indice=0;
										} 
;

LIST_VAR : IDF  VR LIST_VAR
         {if(doubleDeclaration($1)==1)   {printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);}
										 else {
                      strcpy(tabIdf[indice],$1); indice++; 
                      }
         }

          | IDF
          {if(doubleDeclaration($1)==1)   {printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);}
										 else strcpy(tabIdf[indice],$1); indice++; }

          | IDF AFF CST
          {if(doubleDeclaration($1)==1)   {printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);}
					 else {strcpy(tabIdf[indice],$1); indice++;
                     if(strcmp(sauvType, "INTEGER") == 0 && strcmp($3.y , "INTEGER") == 0)
                     {
                      
                      insertValEntiere($1,$3.x);
                      
                     }
                     else{
                      if(strcmp(sauvType, "FLOAT") == 0 && strcmp($3.y , "FLOAT") == 0)
                      {
                        insertReal($1,$3.x);

                      }
                      else
                      {
                        printf("Erreur semantique: incompatibilite des types  a la ligne %d \n",nb_ligne);
                        
                      }
                     }
                    
                     }}

          | IDF AFF POV CST PFR
          {if(doubleDeclaration($1)==1)   {printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);}
										 else {strcpy(tabIdf[indice],$1); indice++;
                     if(strcmp(sauvType, "INTEGER") == 0 && strcmp($4.y , "INTEGER") == 0)
                     {
                      
                      insertValEntiere($1,$4.x);
                      
                     }
                     else{
                      if(strcmp(sauvType, "FLOAT") == 0 && strcmp($4.y , "FLOAT") == 0)
                      {
                        insertReal($1,$4.x);

                      }
                      else
                      {
                        printf("Erreur semantique: incompatibilite des types  a la ligne %d \n",nb_ligne);
                        
                      }
                     }
                    
                     }}
;          











/*********************************   Partie DECLARATION TABLEAU ***********************************************/


TAB_DEC : TYPE LIST_VAR_TAB POINTV {int indice2=0;
																		while(indice2<indice)
																	  {insererTYPE(tabIdf[indice2],sauvType);strcpy(tabIdf[indice2],"");indice2++;}indice=0;}
; 

LIST_VAR_TAB : IDF '[' CST_INT ']' VR LIST_VAR_TAB
{
  
             if(doubleDeclaration($1)==1)
             { 
              printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
              
             }
            else if($3 < 0) {printf("Erreur semantique: l'idice il faut positive  a la ligne %d et a la colonne %d\n",$1);}else{strcpy(tabIdf[indice],$1); indice++;insererCODE($1,"TABLEAU");insertReal($1,$3);}
}
            |IDF '[' CST_INT ']' 
{            
             if(doubleDeclaration($1)==1)
             { 
              printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
              
             }
            else if($3 < 0) {printf("Erreur semantique: l'idice il faut positive  a la ligne %d et a la colonne %d\n",$1);}else{strcpy(tabIdf[indice],$1); indice++;insererCODE($1,"TABLEAU");insertReal($1,$3);}

}
          
;

/*********************************   Partie DECLARATION STRUCT ***********************************************/

STRUCT_DEC : STRUCT IDF {
   if (doubleDeclaration($2)==0) printf("Erreur semantique: structure %s non declarer a la ligne %d et a la colonne %d \n",$2,nb_ligne,col);
   else
   {
    nom=strdup($2);
   }
}LIST_VAR_STRUCT POINTV 


;


LIST_VAR_STRUCT :  IDF VR LIST_VAR_STRUCT
{ if(doubleDeclaration($1)==1)
          printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
          else
          {
            insererTYPE($1,nom);
       
          }
              
             
}
      | IDF
          { if(doubleDeclaration($1)==1)
          printf("Erreur semantique: Double declaration  de %s a la ligne %d et a la colonne %d\n",$1,nb_ligne,col);
          else
          {
            insererTYPE($1,nom);
       
          }
              
             
}
;      



/*********************************   Partie DECLARATION CONSTANTE ***********************************************/

CONST_DEC : CONST LIST_VAR_CONST POINTV  {int indice2=0;
															           while(indice2<indice)
															           {insererTYPE(tabIdf[indice2],sauvType);strcpy(tabIdf[indice2],"");indice2++;}
															           indice=0;
										                       }
;

LIST_VAR_CONST : IDF AFF CST          
{           
                if(doubleDeclaration($1)==1)   
                {
                  printf("erreur semantique double declaration a la ligne %d, colonne %d de l'entite << %s >>\n",nb_ligne,col,$1);
                }
                else{
                  strcpy(tabIdf[indice],$1); indice++; insererCODE($1,"IDF");
                  if(strcmp(sauvType, "INTEGER") == 0 || strcmp(sauvType, "FLOAT") == 0 )
                {
                
                   float val =$3.x;
                    
                   insertReal($1,val);
                   insertCST($1,1);
                  
                
                }
                }
                
                
                
                }
            

               | IDF AFF POV CST PFR 
{           
                if(doubleDeclaration($1)==1)   
                {
                  printf("erreur semantique double declaration a la ligne %d, colonne %d de l'entite << %s >>\n",nb_ligne,col,$1);
                }
                else{
                  strcpy(tabIdf[indice],$1); indice++; insererCODE($1,"IDF");
                  if(strcmp(sauvType, "INTEGER") == 0 || strcmp(sauvType, "FLOAT") == 0 )
                {
                
                   float val =$4.x;
                    
                   insertReal($1,val);
                   insertCST($1,1);
                  
                
                }
                }
                
                
                
                }
 
;


CST : CST_INT  { $$.x=$1;$$.y="INTEGER";}
    | CST_REEL { $$.x=$1;$$.y="FLOAT";}
;


TYPE: INTEGER    {strcpy(sauvType,"INTEGER");} 
	  | FLOAT      {strcpy(sauvType,"FLOAT");} 
;
  
/*****************************************   Partie CODE  ***********************************************/


PARTIE_CODE : AFFECTATION PARTIE_CODE
            | FOR_BOUCLE PARTIE_CODE
            | APPL_STRUCT PARTIE_CODE
            | IF_CONDITION PARTIE_CODE
            | WHILE_BOUCLE PARTIE_CODE
            | commentaire PARTIE_CODE
            |
;

/*****************************************   APPLE DES STRUCT  ***********************************************/


APPL_STRUCT : IDF POINT IDF AFF EXPRESSION POINTV  
{ 
  if (doubleDeclaration($1)==0) printf("Erreur semantique: Variable %s non declarer a la ligne %d et a la colonne %d \n",$1,nb_ligne,col);
  else 
  {
    if(GetType($1) == "INTEGER" || GetType($1) == "FLOAT" | GetType($1) == "STRUCT")
    {
      printf ("ligne %d , entite %s : erreur sementique premier idf doit etre une instance d'une structure \n",nb_ligne,$1);
    }else
    {
      if(doubleDeclaration($3)==0) printf("Erreur semantique: Variable %s non declarer a la ligne %d et a la colonne %d \n",$3,nb_ligne,col);
      else
      {
        if (GetConst($3) == 1){
                            printf ("ligne %d , entite %s : erreur sementique une constante ne peut pas etre modifie \n",nb_ligne,$3);
                            }
                            else
                            {
                              if(strcmp(GetType($3),$5.y)==0)
                              {
                                insertReal($3,$5.x);

                              }
                              else
                              {
                                printf("Erreur semantique: incompatibilite des types  a la ligne %d \n",nb_ligne);
                              } 
                                                       
                              
                            }
                            }
       
    }
  }
}

                            
;

/*******************************************   AFFECTATION  **************************************************/

AFFECTATION :   IDF AFF EXPRESSION POINTV  

{ if (doubleDeclaration($1)==0) printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d non declaree \n",$1,nb_ligne,col); 
else
{
   if (GetConst($1) == 1){ printf ("ligne %d , entite %s : erreur sementique une constante ne peut pas etre modifie \n",nb_ligne,$1);
   }
   else
   {
    quad (":=",$3.chaine,"",$1);
    if(strcmp(GetType($1),$3.y)==0)
      {
        insertReal($1,$3.x);
      }
       else
        {
        printf("Erreur semantique: incompatibilite des types  a la ligne %d \n",nb_ligne);
        } 
    
   }
}
}

            |IDF '['IDF']'AFF EXPRESSION POINTV
            { if (doubleDeclaration($1)==0) printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d non declaree \n",$1,nb_ligne,col);
            else
            {
              if (doubleDeclaration($3)==0) printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d non declaree \n",$3,nb_ligne,col);
             
            }
            }
          
            
            |IDF '['CST']'AFF EXPRESSION POINTV
            { if (doubleDeclaration($1)==0) printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d non declaree \n",$1,nb_ligne,col);}
;

/*****************************************   EXPRESSION  ***********************************************/


EXPRESSION: EXPRESSION ADD EXPRESSION   
           {sprintf(tempC, "T%d",nTemp);nTemp++;
              $$.chaine=strdup(tempC);
              tempC[0]='\0'; 
              quad ("+",$1.chaine,$3.chaine,$$.chaine);
              $$.x=$1.x+$3.x;
              
          }

	        | EXPRESSION SOUS EXPRESSION
          	  {sprintf(tempC, "T%d",nTemp);nTemp++;
              $$.chaine=strdup(tempC);
              tempC[0]='\0'; 
              quad ("-",$1.chaine,$3.chaine,$$.chaine);
              $$.x=$1.x-$3.x;
              
          }
	        | EXPRESSION DIV EXPRESSION 
            {sprintf(tempC, "T%d",nTemp);nTemp++;
              $$.chaine=strdup(tempC);
              tempC[0]='\0'; 
              quad ("/",$1.chaine,$3.chaine,$$.chaine);
              $$.x=$1.x / $3.x;             
              if ($3.x==0){ printf("Erreur semantique: division par 0 interdit a la ligne %d \n",nb_ligne);}
          }
	        | EXPRESSION MULT EXPRESSION 
           {sprintf(tempC, "T%d",nTemp);nTemp++;
              $$.chaine=strdup(tempC);
              tempC[0]='\0'; 
              quad ("*",$1.chaine,$3.chaine,$$.chaine);
              $$.x=$1.x*$3.x;
          }
	        | IDF {$$.y=GetType($1);$$.chaine=strdup($1);$$.x=GetValue($1);}
          | CST_INT {$$.y="INTEGER"; $$.chaine=ToSTR($1);$$.x=$1;  }
          | CST_REEL {$$.y="FLOAT"; $$.chaine=ToSTR($1);$$.x=$1;  }
	        | POV EXPRESSION PFR {$$.y=GetType($2.chaine); $$.chaine=$2.chaine;$$.x=$2.x;}
	;
/*****************************************   LES BOUCLES  ***********************************************/


FOR_BOUCLE :  FOR_A AOV PARTIE_CODE AFR 
{
    quad("BR",ToSTR(d_for),"","");
    q[d_for].op1 = ToSTR(indq);
};

FOR_A : FOR POV IDF DPOINT VARIA DPOINT VARIA DPOINT VARIA PFR
{
    if($5.x<0)
    {
      printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d doit etre supper ou egale a 0 \n",$5.chaine,nb_ligne,col);
    }
    else
    {
      insertValEntiere($3,$5.x);
      if($9.x<0)
      {
        printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d doit etre supper ou egale a 0 \n",$9.chaine,nb_ligne,col);
      }
      else
      {
        if($5.x>$9.x)
        {
          printf("Erreur semantique verifier les borne de la boucle a la ligne %d ",nb_ligne);
        }
        else
        {
          if($7.x<=0)
          {
             printf("Erreur semantique le pas doit etre supperieur a 0 a la ligne %d \n",nb_ligne);

          }else
          { d_for = indq;
          quad("BG","",$3,$9.chaine);
          }
        }
      }
    }
}

;


VARIA : IDF    
          {if (doubleDeclaration($1)==0) printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d non declaree \n",$1,nb_ligne,col);
          else{
            if(strcmp(GetType($1),"INTEGER")==0)
            {
               $$.x=GetValue($1); 
               $$.chaine=$1;
            }
            else
            {
              printf("Erreur semantique: Variable %s a la ligne %d et a la colonne %d doit etre INTEGER \n",$1,nb_ligne,col);
            }
          }
          }
      | CST_INT {$$.x=$1;}   
;


IF_CONDITION :  IF_A ELSE AOV PARTIE_CODE AFR 
              { fin_pos = depiler_qc(&pile1); q[fin_pos].op1= ToSTR(indq); }
             | IF_A
             {indq--; fin_pos = depiler_qc(&pile1);}
;             
IF_A : IF_B AOV PARTIE_CODE AFR
{else_pos = depiler_qc(&pile1); q[else_pos].op1= ToSTR(indq+ 1); empiler_qc(&pile1, indq); quad("BR","","","");}
;
IF_B : IF POV COND PFR
{ empiler_qc(&pile1, indq); quad ("BZ","",strdup($3.chaine),""); }
;

COND : EXPRESSION SUPP EXPRESSION
      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadCompare (4,$1.chaine,$3.chaine,$$.chaine);
      }
      |EXPRESSION INF EXPRESSION
       {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadCompare (3,$1.chaine,$3.chaine,$$.chaine);}

      |EXPRESSION SUPPOUEGL EXPRESSION
                      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadCompare (5,$1.chaine,$3.chaine,$$.chaine);}

      |EXPRESSION INFOUEGL EXPRESSION
                      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadCompare (6,$1.chaine,$3.chaine,$$.chaine);}

      |EXPRESSION EGL EXPRESSION
                      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadCompare (2,$1.chaine,$3.chaine,$$.chaine);}

      |EXPRESSION DIFF EXPRESSION
                      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadCompare (1,$1.chaine,$3.chaine,$$.chaine);}

      |COND AND COND
                      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadLogic (3,$1.chaine,$3.chaine,$$.chaine);}

      |COND OR COND
                      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadLogic (2,$1.chaine,$3.chaine,$$.chaine);}

      |NO EXPRESSION
                      {sprintf(tempC, "T%d",nTemp);nTemp++;$$.chaine=strdup(tempC);tempC[0]='\0'; createQuadLogic (1,$2.chaine,"",$$.chaine);}
      |EXPRESSION                 
;




WHILE_BOUCLE : WHILE_A PARTIE_CODE AFR
{
     quad("BR",ToSTR(d_while),"","");
     q[fin_while].op1 = ToSTR(indq);
}
 ;

WHILE_A : WHILE_B POV COND PFR AOV
{
    fin_while = indq;
    quad("BZ","",$3.chaine,"");
}
;

WHILE_B : WHILE  
{
  d_while = indq;
}
; 




%%

int yyerror (char* msg)
{  printf (" %s ligne %d cologne %d \n",msg,nb_ligne,col); exit (0);}
 int main()
 {

    initialisation();
    yyparse();
    afficher();
    printf("\n\n");
    printf("""********************* Les QUAD Avant Optimisation ***********************\n\n");
    afficherQuad();
    printf("\n");
    printf("""********************* Optimisation  ***********************\n\n");
    optimisation(); 
    printf("""********************* Les QUAD Apres Optimisation ***********************\n");
    afficherQuad();
    printf("\n");
    assembler();
    printf("Code machine est generer ...\n\n");

    
 

}
int yywrap() {
    return 1; 
}