%{
#include <stdio.h>
#include <stdlib.h>

int yyerror(char const *msg);	
int yylex(void);
extern int yylineno;
%}
%token BOOLEAN
%token KEY_WORD
%token REAL
%token ID
%token INTEGER_LITERAL
%token OP_REL
%token OP_ARITH
%token AFF
%token SEMICOLON
%token OPEN_PAR
%token CLOSE_PAR
%token OPEN_BRACKET
%token CLOSE_BRACKET
%token OPEN_SQUARE_BRACKET
%token CLOSE_SQUARE_BRACKET
%token DOT
%token DOUBLE_QUOTE
%token CLASS
%token COMMA
%token PRIMITIVE_TYPE
%token VOID
%token IF
%token ELSE
%token WHILE
%token RETURN
%token EXTENDS
%token IMPLEMENTS
%%

program : class_declaration
        ;

class_declaration : class_signature OPEN_BRACKET class_body CLOSE_BRACKET
                    | error OPEN_BRACKET class_body CLOSE_BRACKET {yyerror("Error in class declaration");}
                    | class_signature OPEN_BRACKET error CLOSE_BRACKET {yyerror("Error in class body");}
                    | class_signature OPEN_BRACKET class_body error {yyerror("Missing closing }");}
                    ;

class_signature: CLASS ID
                | CLASS ID EXTENDS ID
                | CLASS ID IMPLEMENTS ID
                | CLASS ID EXTENDS ID IMPLEMENTS ID
                | error ID {yyerror("Error in class signature");}
                | CLASS error {yyerror("Error in class signature");}
                | CLASS ID EXTENDS error {yyerror("Error in class signature");}
                | CLASS ID IMPLEMENTS error {yyerror("Error in class signature");}
                | CLASS ID EXTENDS ID IMPLEMENTS error {yyerror("Error in class signature");}
                
                ;
class_body : field_declarations
              | method_declarations
              | field_declarations method_declarations
            ;

method_declarations: method_declaration
                    | method_declarations method_declaration
                    ;
method_declaration: VOID ID OPEN_PAR CLOSE_PAR OPEN_BRACKET method_body CLOSE_BRACKET
                  ;

method_body : field_declarations
            | statements
            | field_declarations statements
            ;

statements : statement
            | statements statement
            ;

statement : expression SEMICOLON
          | variable AFF expression SEMICOLON
          | field_declaration
          | IF OPEN_PAR expression CLOSE_PAR OPEN_BRACKET statements CLOSE_BRACKET
          | IF OPEN_PAR expression CLOSE_PAR OPEN_BRACKET statements CLOSE_BRACKET ELSE OPEN_BRACKET statements CLOSE_BRACKET
          | WHILE OPEN_PAR expression CLOSE_PAR OPEN_BRACKET statements CLOSE_BRACKET
          | RETURN expression SEMICOLON
          ;

field_declarations : field_declaration
                   | field_declarations field_declaration
                   ;

field_declaration : type variable SEMICOLON
                   | type variable AFF expression SEMICOLON
                   ;

type : PRIMITIVE_TYPE
     ;

variable : ID
          | ID OPEN_SQUARE_BRACKET expression CLOSE_SQUARE_BRACKET
         ;

expression : expression OP_REL expression %prec OP_REL
           | expression OP_ARITH expression %prec OP_ARITH
           | OPEN_PAR expression CLOSE_PAR
           | INTEGER_LITERAL
           | REAL
           | BOOLEAN
           | variable
           | method_call
           ;

method_call : variable DOT ID OPEN_PAR arguments CLOSE_PAR
            | ID OPEN_PAR arguments CLOSE_PAR
            ;

arguments : expression
          | arguments COMMA  expression
          ;

%%

int yyerror(char const *msg) {
       
	
	fprintf(stderr, "%s %d\n", msg,yylineno);
	return 0;
	
	
}

extern FILE *yyin;

int main(int argc, char* argv[]) {
  if (argc < 2) {
    printf("Usage: %s filename\n", argv[0]);
    return 1;
  }

  FILE* fp = fopen(argv[1], "r");
  if (fp == NULL) {
    printf("Error: cannot open file '%s'\n", argv[1]);
    return 1;
  }
  yyin = fp;
  yyparse();

  fclose(fp);
  return 0;
}
