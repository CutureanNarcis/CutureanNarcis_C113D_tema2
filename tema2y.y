%{
	#include<iostream>
	#include <stdio.h>
	#include <string.h>

    	int EsteCorecta = 0;
	

	int yylex();
	int yyerror(const char *msg);

     
	char msg[500];

	class TVAR
	{
	     char* nume;
	     int valoare;
	     TVAR* next;
	  
	  public:
	     static TVAR* head;
	     static TVAR* tail;

	     TVAR(char* n, int v = -1);
	     TVAR();
	     int exists(char* n);
             void add(char* n, int v = -1);
             int getValue(char* n);
	     void setValue(char* n, int v);
	     void Print_TVAR();

	};

	TVAR* TVAR::head;
	TVAR* TVAR::tail;
	
	void TVAR::Print_TVAR()
	{
	 TVAR*tmp=TVAR::head;
	 printf("Table values:\n");
	 if(tmp==NULL)
	 printf("Empty!\n");
	 while(tmp!=NULL)
	{
	 printf(" %s  %d\n",tmp->nume, tmp->valoare);
	 tmp=tmp->next;
	}
	}
	TVAR::TVAR(char* n, int v)
	{
	 this->nume = new char[strlen(n)+1];
	 strcpy(this->nume,n);
	 this->valoare = v;
	 this->next = NULL;
	}

	TVAR::TVAR()
	{
	  TVAR::head = NULL;
	  TVAR::tail = NULL;
	}

	int TVAR::exists(char* n)
	{
	  TVAR* tmp = TVAR::head;
	  while(tmp != NULL)
	  {
	    if(strcmp(tmp->nume,n) == 0)
	      return 1;
            tmp = tmp->next;
	  }
	  return 0;
	 }

         void TVAR::add(char* n, int v)
	 {
	   TVAR* elem = new TVAR(n, v);
	   if(head == NULL)
	   {
	     TVAR::head = TVAR::tail = elem;
	   }
	   else
	   {
	     TVAR::tail->next = elem;
	     TVAR::tail = elem;
	   }
	 }

         int TVAR::getValue(char* n)
	 {
	   TVAR* tmp = TVAR::head;
	   while(tmp != NULL)
	   {
	     if(strcmp(tmp->nume,n) == 0)
	      return tmp->valoare;
	     tmp = tmp->next;
	   }
	   return -1;
	  }

	  void TVAR::setValue(char* n, int v)
	  {
	    TVAR* tmp = TVAR::head;
	    while(tmp != NULL)
	    {
	      if(strcmp(tmp->nume,n) == 0)
	      {
		tmp->valoare = v;
	      }
	      tmp = tmp->next;
	    }
	  }

	TVAR* ts = NULL;
%}

%union { char* nume; int valoare;}

%token TOK_PROGRAM TOK_VAR TOK_BEGIN TOK_END  TOK_INTEGER 
%token TOK_READ TOK_WRITE TOK_FOR TOK_DO TOK_TO TOK_ID  TOK_INT
%token TOK_PUNCTVIRGULA TOK_DOUAPUNCTE TOK_VIRGULA TOK_DOUAPUNCTEEGAL
%token TOK_PLUS TOK_MINUS TOK_INMULTIRE TOK_IMPARTIRE 
%token TOK_PARANTEZASTANGA TOK_PARANTEZADREAPTA 


%type <valoare> TOK_INT exp term factor
%type <nume> TOK_ID 

%start prog

%left TOK_PLUS TOK_MINUS 
%left TOK_INMULTIRE TOK_IMPARTIRE



%%

prog : TOK_PROGRAM progname TOK_VAR declist TOK_BEGIN stmtlist TOK_END  { EsteCorecta = 1;}
	
;
progname : TOK_ID
	{
	ts=new TVAR();
	ts->add($1);
	}
;
declist : dec
	|  declist TOK_PUNCTVIRGULA dec
;
dec : idlist TOK_DOUAPUNCTE type
;
type : TOK_INTEGER
;
idlist : TOK_ID
	{
	if(ts->exists($1)==0)	
	ts->add($1);
	}
	|   idlist TOK_VIRGULA TOK_ID
	{
	if(ts->exists($3)==0)	
	ts->add($3);
	}
;
stmtlist : stmt
	|   stmtlist TOK_PUNCTVIRGULA stmt
;
stmt : assign
	| read
	| write
	| for
;
assign : TOK_ID TOK_DOUAPUNCTEEGAL exp { ts->setValue($1,$3); }
;
exp : term
	| exp TOK_PLUS term { $$=$1+$3; }
	| exp TOK_MINUS term { $$=$1-$3; }
;
term : factor
	| term TOK_IMPARTIRE factor { if($3==0) { printf("\nSemantic error:Divided by zerro!\n"); } else $$=$1/$3; }
	| term TOK_INMULTIRE factor { $$=$1*$3; }
;
factor : TOK_ID
	{
	if(ts->exists($1)==0)
	{
	printf("Semantic error:Variable not declared!\n");
	}
	else
	$$=ts->getValue($1);
	}
	| TOK_INT {$$=$1; }
	| TOK_PARANTEZASTANGA exp TOK_PARANTEZADREAPTA {$$=$2; }
;
read : TOK_READ TOK_PARANTEZASTANGA idlist TOK_PARANTEZADREAPTA
;
write : TOK_WRITE TOK_PARANTEZASTANGA idlist TOK_PARANTEZADREAPTA
;
for : TOK_FOR indexexp TOK_DO body
;
indexexp : TOK_ID TOK_DOUAPUNCTEEGAL exp TOK_TO exp

;
body : stmt
	| TOK_BEGIN stmtlist TOK_END
;	 
	

%%

int main()
{
	yyparse();
	
	if(EsteCorecta == 1)
	{
		printf(" -Structure is Correct!\n");		
	}	
	else
	{
		printf(" -Structure is Incorrect!\n");
	}
	ts->Print_TVAR();
       return 0;
}

int yyerror(const char *msg)
{
	printf("Error: %s", msg);
	return 1;
}
