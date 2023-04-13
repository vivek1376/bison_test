%{
  #include <stdio.h>
  #include <string.h>
  #include "projlang.tab.h"  // to get the token types from Bison

%}


%%


[ \t\n]	;
[pP]rogram	{ return PROGRAM_RW; }
begin   { return BEGIN_RW; }
is		{ return IS_RW; }
end		{ return END_RW; }
"."		{ return DOT; }


[0-9]+	{ yylval.ival = atoi(yytext); return INT; }
[a-zA-Z0-9]+	{ yylval.sval = strdup(yytext); return STRING; }


%%



