%{
	

#include <stdio.h>	
#include <stdlib.h>
 			
int yyerror(char const *msg);	
int yylex(void);
extern int yylineno;

%}

%token PROGRAM 
%token point_virgule
%token point
%token ID
%token var

 
/*%error-verbose*/
%start programmes

%%
                                                           
programmes		     : PROGRAM ID point_virgule
                              |error ID point_virgule            {yyerror (" program attendu on line : "); YYABORT}
                              |PROGRAM error point_virgule       {yyerror (" nom du programme invalide on line : "); YYABORT} 
                              |PROGRAM ID error                  {yyerror (" point virgule attendu on line : "); YYABORT}
                              ;



%% 

int yyerror(char const *msg) {
       
	
	fprintf(stderr, "%s %d\n", msg,yylineno);
	return 0;
	
	
}

extern FILE *yyin;

int main()
{
 yyparse();
 
 
}

  
                   
