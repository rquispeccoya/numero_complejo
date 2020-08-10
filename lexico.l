%{

#include "sintactico.tab.h"
#include "string.h"

/* 
extern int yylval;
*/

int yyparse();

%}

numero [0-9]+   
real {numero}\.{numero}


%%

-?({numero}|{real}) 	{yylval.numero=atof(yytext);return NUM;} //evalua la parte entera
[+|-]({numero}|{real})i 	{yylval.img=atof(yytext); return IMG;}//evalua la parte imaginaria

"\n"     {return FINLINEA;} //salto de linea
"("	{return INI_PAR;}
")"	{return FIN_PAR;}
"+"	{return MAS;} //operador suma
"-"	{return MENOS;} //operador resta
"*"	{return PRODUCTO;}  //operador producto
"/"	{return DIV;}  //operador division
.			;

%%

int yywrap(){ return 0;}


