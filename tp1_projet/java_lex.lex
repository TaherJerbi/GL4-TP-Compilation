%option noyywrap
%option yylineno

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
INT  ({NONZERODIGIT}{DIGIT}+)|{DIGIT}
REAL ("-")?INT("."{DIGIT}+)(("E"|"e")"-"?{DIGIT}+)?
ID {LETTER}({LETTER}|{DIGIT}|_)*
INVALID_ID {DIGIT}+({LETTER}|_)+({LETTER}|{DIGIT}|_)*
OP_ARITH  "+"|"-"|"*"|"/"
OP_REL "<"|">"|"=="|"<="|">=" 
AFF "=" 
START_COMMENT "/*"
KEY_WORD class|main|if|else|for|while|do|public|static|void|for|switch|break|case|continue|try|catch|extends|implements|interface|int|float|boolean


%%
{WS}+                   /* ignore whitespace */
{START_COMMENT}         { BEGIN(comment); }
<comment>[^*\n]*        /* consume anything that isn't a comment end */
<comment>"*"+[^*/\n]*   /* consume *'s not followed by / or newline */
<comment>\n             { ++line_nb; }
<comment>"*"+"/"        { BEGIN(INITIAL); }
{BOOLEAN}               { printf("<BOOLEAN_LITERAL | %s > \n", yytext); }
{KEY_WORD}              { printf("<KEY_WORD | %s> \n",yytext); }
{REAL}                  { printf("<FLOAT | %s > \n", yytext); } 
{ID}                    { printf("<IDENTIFIER | %s > \n", yytext); }
{INT}                   { printf("<INTEGER_LITERAL | %s > \n", yytext); }
{OP_REL}                { printf("<OP_REL | %s > \n" , yytext ) ; }
{OP_ARITH}              { printf("<OP_ARITH | %s > \n" , yytext ) ; }
{AFF}                   { printf("<OP_AFF | %s > \n" , yytext ) ; }
\n                      { ++line_nb ;}
{INVALID_ID}            { fprintf(stderr,"error at line %d variable names should not start with a digit",yylineno); } 
";"                     { printf("<SEMI_COL > \n",yytext); } 
"("                     { printf("<OPEN_PAR > \n",yytext); }
")"                     { printf("<CLOSED_PAR > \n",yytext); }
"{"                     { printf("<OPEN_BRACKET > \n",yytext); }
"}"                     { printf("<CLOSE_BRACKET > \n",yytext); }
"["                     { printf("<OPEN_SQUARE_BRACKET > \n",yytext); }
"]"                     { printf("<CLOSE_SQUARE_BRACKET > \n",yytext); }
"."                     { printf("<DOT > \n",yytext); }
"\""                    { printf("<QUOTE > \n",yytext); }
.                       { fprintf(stderr, "error at line %d: unknown character %s\n", yylineno, yytext); }
%%

int main(){
    FILE *fp ; 
    char filename[50];
    printf("Enter a file name : \n") ; 
    scanf("%s",filename);
    fp = fopen(filename,"r"); 
    yyin = fp ;
    yylex();
    printf("\nNumber of lines in the given input is %d \n" , line_nb  ) ;
    return 0 ; 
}
