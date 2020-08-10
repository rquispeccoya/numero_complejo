%{
#include <stdio.h>
#include <string.h>
#include <math.h>
#define YYDEBUG 1

extern int yylex(void);
extern char *yytext;
void yyerror(char *s);
int i=0;  //contador de lineas
%}

//definimos la estructura
%union{
 struct complejo{
	float entero;
	float imaginario;
  } nc;
 float numero;
 float img;
}

//capturamos los tokens de la parte entera y imaginaria
%token <numero>NUM
%token <img>IMG

//capturamos los tokens de las operaciones
%token FINLINEA
%left INI_PAR FIN_PAR
%left MAS MENOS
%left PRODUCTO DIV

 
%type <nc> c
%type <nc> d
%type <nc> e

%%

//establecemos diferentes condiciones para los casos de salida  :

s: c FINLINEA {
		//resultado positivo  a+bi
		if($1.imaginario>0&&$1.entero!=0){
			i++;
			printf("Linea %d -> Total : %.4f + %.4f i \n",i,$1.entero,$1.imaginario);}

		//resultado negativo a-bi
		else if ($1.imaginario<0&&$1.entero!=0){
			i++;
			printf("Linea %d -> Total : %.4f %.4f i \n",i,$1.entero,$1.imaginario);}

		//resultado cero   0
		else if ($1.imaginario==0&&$1.entero==0){
			i++;
			printf("Linea %d -> Total : %d \n",i,0);}

		//solo entero  a
		else if ($1.imaginario==0&&$1.entero!=0){
			i++;
			printf("Linea %d -> Total : %.4f \n",i,$1.entero);}

		//solo imaginario  ai
		else if ($1.imaginario!=0&&$1.entero==0){
			i++;
			printf("Linea %d -> Total : %.4f i \n",i,$1.imaginario);}
	      }

//con esta regla podemos ingresar mas ejercicios a resolver
|s c FINLINEA {if($2.imaginario>0&&$2.entero!=0){
			i++;
			printf("Linea %d -> Total : %.4f + %.4f i \n",i,$2.entero,$2.imaginario);}

		else if ($2.imaginario<0&&$2.entero!=0){
			i++;
			printf("Linea %d -> Total : %.4f %.4f i \n",i,$2.entero,$2.imaginario);}

		else if ($2.imaginario==0&&$2.entero==0){
			i++;
			printf("Linea %d -> Total : %d \n",i,0);}

		else if ($2.imaginario==0&&$2.entero!=0){
			i++;
			printf("Linea %d -> Total : %.4f \n",i,$2.entero);}

		else if ($2.imaginario!=0&&$2.entero==0){
			i++;
			printf("Linea %d -> Total : %.4f i \n",i,$2.imaginario);}
	      }
;


//Operacion suma y resta 

	//SUMA
c:	  c MAS d   {$$.entero = $1.entero + $3.entero;$$.imaginario = $1.imaginario + $3.imaginario;}

	//RESTA	
	| c MENOS d {$$.entero = $1.entero - $3.entero;$$.imaginario = $1.imaginario - $3.imaginario;}	
	| d	    {$$.entero=$1.entero;$$.imaginario=$1.imaginario;}
;


//Operacion producto y division	

	//MULTIPLICACION	
d:	 d PRODUCTO e {$$.entero = $1.entero*$3.entero+($1.imaginario*$3.imaginario)*(-1);//operacion de la parte entera
		      $$.imaginario = $1.entero*$3.imaginario+$1.imaginario*$3.entero;}//operacion de la parte imaginaria

	//DIVISION
	|d DIV e     { //verificamos que el divisor sea diferente de cero 
			if($3.entero==0&&$3.imaginario==0){
				printf("Division por cero en la linea : %d   \n",i+1);
			}
			//si es diferente de cero realiza la operacion
			else{
				//multiplicamos el numerador y denominador por el conjugado del denominador
				float a=pow($3.entero,2)+(pow($3.imaginario,2)); 
				$$.entero = ($1.entero*$3.entero+($1.imaginario*$3.imaginario))/a; //operacion de la parte entera
				$$.imaginario =( $1.entero*(-1)*$3.imaginario+$1.imaginario*$3.entero)/a; //operacion de la imaginaria
			}
		     }
	| e	     {$$.entero=$1.entero;$$.imaginario=$1.imaginario;}
;

//cadena a aceptar de la expresion (a+bi)
e: 	  INI_PAR c FIN_PAR {$$.entero=$2.entero;$$.imaginario=$2.imaginario;}//capturamos la parte entera y imaginaria cuando esten dentro de los parentesis
	| NUM IMG 	  {$$.entero=$1;$$.imaginario=$2;}//capturamos la parte entera y imaginaria
	|INI_PAR error FIN_PAR {printf("Error de sintaxis en la linea : %d    \n",i+1);yyerrok;}//si encuentra algun error de sintaxis dentro de los parentesis
;


%%
void yyerror(char *s)
{
  //printf("Error de sintaxis");
}
int main (int argc , char ** argv ){
	yydebug=0;
	yyparse();
	return 0;
}


