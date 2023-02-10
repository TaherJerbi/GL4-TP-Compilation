%option yylineno
delim     [ \t]
bl        {delim}+
chiffre   [0-9]
lettre    [a-zA-Z]
id        ({lettre}|"_")({lettre}|{chiffre}|"_")*
nb        ("-")?{chiffre}+("."{chiffre}+)?(("E"|"e")"-"?{chiffre}+)?
iderrone  {chiffre}({lettre}|{chiffre}|"_")*
ouvrante  (\()
fermante  (\))
COMMENT_LINE        "//"

%%

{bl}                                                                                 /* pas d'actions */
"\n" 			                                                             ++yylineno;
"program"                                                                            printf(" keyword \n");
"begin"                                                                              printf(" keyword \n");
"end"                                                                                printf(" keyword \n");
"int"                                                                                printf(" type \n");
{ouvrante}                                                                           printf(" parenthese_ouvrante \n");
{fermante}                                                                           printf(" parenthese_fermante \n");
{id}                                                                                 printf(" Identifier \n");
{nb}                                                                                 printf(" Number \n");
"="	                                                                             printf(" OPPAFFECT \n");
{COMMENT_LINE}         								     printf(" COMMENT \n");

{iderrone}              {fprintf(stderr,"illegal identifier \'%s\' on line :%d\n",yytext,yylineno);}
	

%%

int main(int argc, char *argv[]) 
{
     yyin = fopen(argv[1], "r");
     yylex();
     fclose(yyin);
}

yywrap()
{
	return(1);
}
