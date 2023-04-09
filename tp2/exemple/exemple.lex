%{	
 /* We usually need these... */	
 #include <stdio.h>	
 #include <stdlib.h>	
 		
 #include "exemple.tab.h"	                                                                         	
 /* Local stuff we need here... */	
#include <math.h>	 			
%}


%option yylineno
delim     [ \t]
bl        {delim}+
chiffre   [0-9]
lettre    [a-zA-Z]
id        {lettre}({lettre}|{chiffre})*
nb        ("-")?{chiffre}+("."{chiffre}+)?(("E"|"e")"-"?{chiffre}+)?
iderrone  {chiffre}({lettre}|{chiffre})*
ouvrante  (\()
fermante  (\))

%%

{bl}                                                                                 /* pas d'actions */
"\n" 			                                                             ++yylineno;
"program"                                                                            return PROGRAM;
";"                                                                                  return point_virgule;
"."                                                                                  return point;
{id}                                                                                 return ID;

{iderrone}              {fprintf(stderr,"illegal identifier \'%s\' on line :%d\n",yytext,yylineno);}
	
.			{fprintf(stderr,"Illegal character \'%s\' on line :%d\n",yytext,yylineno);}


%%
int yywrap()
{
	return(1);
}

