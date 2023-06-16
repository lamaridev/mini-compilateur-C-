%{ 
    
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include "synt.tab.h"


extern YYSTYPE yylval;
int nb_ligne=1;
int col=1;

 
void rechercher (char entite[], char code[], char type[], float val,int y);


%}

%option noyywrap

lettre  [a-zA-Z]
chiffre [0-9]
IDF     {lettre}({lettre}|{chiffre})*
cst_int  ([1-9][0-9]*|0)|(\([-+]?[1-9][0-9]*\))
cst_reel ([0-9]+\.[0-9]+)|(\([-+]?[0-9]+\.[0-9]+\))

commentaire "%%"(.)*

%%
"INTEGER" 							{rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(INTEGER);}
"FLOAT" 							{rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(FLOAT);}
"CONST" 							{rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(CONST);}
"IF"  								{rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(IF);}
"ELSE"   							{rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(ELSE);}
"STRUCT"                            {rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(STRUCT);}
"WHILE"                             {rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(WHILE);}
"FOR"                               {rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(FOR);}
"CODE"                              {rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(CODE);}
"VAR"                               {rechercher (yytext,"Mot cle"," ",0, 1);col = col + yyleng ;return(VAR);}
{IDF}								{rechercher (yytext,"IDF","",0, 0); col = col + strlen(yytext);col = col + yyleng ;yylval.STRING=strdup(yytext);if(yyleng<=8)return(IDF) ;else  printf("la taille de idf ne depasse pas 8 ") ;}

{cst_int}    { 
                char numStr[256] = {0}; 
                int i, j = 0;
                for (i = 0; yytext[i] != '\0'; i++) {
                    if (isdigit(yytext[i]) || yytext[i] == '-' || yytext[i] == '+') {
                        numStr[j] = yytext[i];
                        j++;
                    }
                }
                yylval.ENTIER = atoi(numStr);
                 
                if((atoi(yytext)>-32768)&(atoi(yytext)<32768))
 			{
			col = col + strlen(yytext);
            
			
 			return CST_INT;
			}else printf("la valeur attribue depasse l'intervale des nombres entiers") ;
}							
            


{cst_reel}    { 
                char numStr[256] = {0};
                int i, j = 0;
                for (i = 0; yytext[i] != '\0'; i++) {
                    if (isdigit(yytext[i]) || yytext[i] == '-' ||  yytext[i] == '+' ||yytext[i] == '.') {
                        numStr[j] = yytext[i];
                        j++;
                    }
                }
                yylval.REEL = atof(numStr);
                col = col + strlen(yytext); 
				
                return CST_REEL;
            }
";"                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(POINTV);}													 
"+" 								{rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(ADD);}
"-" 								{rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(SOUS);}
"*" 								{rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(MULT);}
"/"          						{rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(DIV);}
":" 								{rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(DPOINT);}
">"                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(SUPP);}
"<"                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(INF);}
">="                                {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(SUPPOUEGL);}
"<="                                {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(INFOUEGL);}
"=="                                {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(EGL);}
"!="                                {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(DIFF);}
"["                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return('[');}
"]"                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(']');}
"&&"                                {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(AND);}
"!"                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(NO);}
"||"                                {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(OR);}
"."                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(POINT);}
"="                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(AFF);}
"(" 								{rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(POV);}
")" 								{rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(PFR);}
"{"                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(AOV);}
"}"                                 {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(AFR);}
","				                    {rechercher (yytext,"Separateur",0,0, 2);col = col + yyleng ;return(VR);}
{commentaire}                       {col = col + yyleng ;}
[\n]                                {col=1;nb_ligne++;}
[ \t]                               {col = col + yyleng ;}
. return("erreur lexical ala ligne %d \n", nb_ligne);

