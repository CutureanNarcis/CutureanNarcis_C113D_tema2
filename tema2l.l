%{
	#include "y.tab.h"


	


%}



%%
"PROGRAM"	{ return TOK_PROGRAM;}
"VAR"		{ return TOK_VAR;}
"BEGIN"		{ return TOK_BEGIN;}
"END"		{ return TOK_END;}
"FOR"		{ return TOK_FOR;}
"DO"		{ return TOK_DO;}
"TO"		{ return TOK_TO;}
"READ"		{ return TOK_READ;}
"WRITE"		{ return TOK_WRITE;}
"INTEGER"	{ return TOK_INTEGER;}
","		{ return TOK_VIRGULA;}
"+"		{ return TOK_PLUS;}
"-"		{ return TOK_MINUS;}
"*"		{ return TOK_INMULTIRE;}
"/"		{ return TOK_IMPARTIRE;}
"("		{ return TOK_PARANTEZASTANGA;}
")"		{ return TOK_PARANTEZADREAPTA;}
":="		{ return TOK_DOUAPUNCTEEGAL;}
":"		{ return TOK_DOUAPUNCTE;}
";"		{ return TOK_PUNCTVIRGULA;}
0|[1-9][0-9]*		{ yylval.valoare=atoi(yytext); return TOK_INT;}
[a-zA-Z][a-z0-9_]*	{ yylval.nume=new char[strlen(yytext)+1]; strcpy(yylval.nume,yytext); return TOK_ID;}
[\n\f\v\t]		{ ;}

%%

