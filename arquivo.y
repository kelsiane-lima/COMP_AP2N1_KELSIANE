%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

int yylex();
void yyerror (char *s){
	printf("%s\n", s);
}

	typedef struct vars{
		char name[50];
		float valor;
		struct vars * prox;
	}VARS;
	
	//insere uma nova variável na lista de variáveis
	VARS * ins(VARS*l,char n[], float v){
		VARS*new =(VARS*)malloc(sizeof(VARS));
		strcpy(new->name,n);
        new->valor=v;
		new->prox = l;
		return new;
	}
	
	//busca uma variável na lista de variáveis
	VARS *srch(VARS*l,char n[]){
		VARS*aux = l;
		while(aux != NULL){
			if(strcmp(n,aux->name)==0)
				return aux;
			aux = aux->prox;
		}
		return aux;
	}
	
	VARS *l1;
%}

%union{
	float flo;
	char str[50];
	}

%token <flo>NUM_REAL
%token <str>VAR
%token <str>STR
%token DECL
%token INPUT
%token OUTPUT
%token FIM
%token INI
%left '+' '-'
%left '*' '/'
%right '^' '$'
%right NEG
%type <flo> exp
%type <flo> valor


%%



prog: INI cod FIM
	;

cod: cod cmdos
	|
	;

cmdos: DECL VAR {
		VARS * aux = srch(l1,$2);
		if (aux == NULL)
			l1 = ins(l1,$2,0);
		else
			printf ("Redeclaração de variável: %s\n",$2);
				  }
	|
	
		OUTPUT exp {
			
			printf ("%.2f \n",$2);
				}
        |
		OUTPUT STR {
            		int i = strlen($2);

                	$2[0] = ' ';
                	$2[i-1] = '\0';
          
			 printf ("%s ",$2);
		}

	| 	
	
       INPUT VAR {

			VARS * aux = srch(l1,$2);
			if (aux == NULL){
				printf ("variável nao definida: %s\n",$2);
                	        return -1;
				} 
			else {
                            	float x;
		                scanf ("%f",&x);
                            	l1 = ins(l1,$2,x);
        			}
		}
    	|
	
	VAR '=' exp {
			VARS * aux = srch(l1,$1);
			if (aux == NULL)
				printf ("Variável não declarada: %s\n",$1);
			else
				aux -> valor = $3;
		}
	;

exp: exp '+' exp {$$ = $1 + $3;}
	|exp '-' exp {$$ = $1 - $3;}
	|exp '*' exp {$$ = $1 * $3;}
	|exp '/' exp {$$ = $1 / $3;}
	|'(' exp ')' {$$ = $2;}
	|exp '^' exp {$$ = pow($1,$3);}
    |'$''('exp')' {$$ = sqrt($3);}
	|'-' exp %prec NEG {$$ = -$2;}
	|valor {$$ = $1;}
	|VAR {
			VARS * aux = srch (l1,$1);
			if (aux == NULL)
				printf ("Variável não declarada: %s\n",$1);
			else
				$$ = aux->valor;
			}
	;

valor: NUM_REAL {$$ = $1;}
	;

%%

#include "lex.yy.c"

int main(){
	l1 = NULL;
	yyin=fopen("entrada.txt","r");
	yyparse();
	yylex();
	fclose(yyin);
return 0;
}
int yywrap(){
return 1;
}
