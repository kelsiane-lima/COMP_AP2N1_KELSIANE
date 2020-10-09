%{

%}

COMENT "#"
NUM_REAL [0-9]+\.?[0-9]*
VAR [a-zA-Z]+[0-9]*
DECL "float"
STR "\"".*"\""
INPUT "kin>>"
OUTPUT "kout<<"
INI "k_inicio"
FIM "k_fim"
%%

{COMENT}.* {;}
	
{DECL} {return DECL;}

{STR} {
	strcpy(yylval.str,yytext);
	return STR;
	}

{OUTPUT} {return OUTPUT;}
{INPUT} {return INPUT;}
{INI} {return INI;}			
	
{FIM} {return FIM;}

{NUM_REAL} {
	yylval.flo = atof(yytext);
	return NUM_REAL;
	}
	
{VAR} {
	strcpy (yylval.str,yytext);
	return VAR;
	}

[-+()=/*^$] {return *yytext;}
	
[\ \n\t]*	{;}

. {

printf("Erro de Sintaxe (%s)\n",yytext);
return -1;
}
%%
