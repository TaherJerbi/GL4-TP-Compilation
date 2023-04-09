%option noyywrap
%option yylineno
%{	
 /* We usually need these... */	
 #include <stdio.h>	
 #include <stdlib.h>	
 		
 #include "mini_java.tab.h"	                                                                         	
 #include <math.h>	 			
%}

%{
int line_nb = 1;
%}

%x comment 

BOOLEAN "true"|"false" 
DELIM [ \t]
WS {DELIM}+
NONZERODIGIT [1-9]
DIGIT 0|{NONZERODIGIT}
LETTER [a-zA-Z]
INTEGER_LITERAL  ({NONZERODIGIT}{DIGIT}+)|{DIGIT}
REAL ("-")?INT("."{DIGIT}+)(("E"|"e")"-"?{DIGIT}+)?
ID {LETTER}({LETTER}|{DIGIT}|_)*
INVALID_ID {DIGIT}+({LETTER}|_)+({LETTER}|{DIGIT}|_)*
OP_ARITH  "+"|"-"|"*"|"/"
OP_REL "<"|">"|"=="|"<="|">=" 
AFF "=" 
START_COMMENT "/*"
KEY_WORD main|while|do|public|static|for|switch|break|case|continue|try|catch|interface
PRIMITIVE_TYPE int|float|boolean
VOID void
CLASS class
IF if
ELSE else
WHILE while
RETURN return
EXTENDS extends
IMPLEMENTS implements


%%
{WS}+                   /* ignore whitespace */
{START_COMMENT}         { BEGIN(comment); }
<comment>[^*\n]*        /* consume anything that isn't a comment end */
<comment>"*"+[^*/\n]*   /* consume *'s not followed by / or newline */
<comment>\n             { ++line_nb; }
<comment>"*"+"/"        { BEGIN(INITIAL); }
{BOOLEAN}               return BOOLEAN;
{CLASS}                 return CLASS;
{IF}                    return IF;
{ELSE}                  return ELSE;
{WHILE}                 return WHILE;
{RETURN}                return RETURN;
{EXTENDS}               return EXTENDS;
{IMPLEMENTS}            return IMPLEMENTS;
{KEY_WORD}              return KEY_WORD;
{PRIMITIVE_TYPE}        return PRIMITIVE_TYPE;
{VOID}                  return VOID;
{REAL}                  return REAL;
{ID}                    return ID;
{INTEGER_LITERAL}       return INTEGER_LITERAL;
{OP_REL}                return OP_REL;
{OP_ARITH}              return OP_ARITH;
{AFF}                   return AFF;
[\n\r]                  { ++line_nb ;}
{INVALID_ID}            { fprintf(stderr,"error at line %d variable names should not start with a digit\n",yylineno); } 
";"                     return SEMICOLON;
"("                     return OPEN_PAR;
")"                     return CLOSE_PAR;
"{"                     return OPEN_BRACKET;
"}"                     return CLOSE_BRACKET;
"["                     return OPEN_SQUARE_BRACKET;
"]"                     return CLOSE_SQUARE_BRACKET;
"."                     return DOT;
"\""                    return DOUBLE_QUOTE;
","                     return COMMA;
.                       { fprintf(stderr,"error at line %d unknown character\n",yylineno); }
%%


