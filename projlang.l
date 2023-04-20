%{
  #include <stdio.h>
  #include <string.h>
  #include "tree.h"
  #include "projlang.tab.h"  // to get the token types from Bison

%}


%%


[ \t\n]	;
[pP]rogram	{ yylval.sval = strdup(yytext); return PROGRAM_RW; }
is		{ yylval.sval = strdup(yytext); return IS_RW; }
begin   { yylval.sval = strdup(yytext); return BEGIN_RW; }
end		{ yylval.sval = strdup(yytext); return END_RW; }
global  { yylval.sval = strdup(yytext); return GLOBAL_RW; }

procedure   { yylval.sval = strdup(yytext); return PROCEDURE_RW; }
variable  { yylval.sval = strdup(yytext); return VARIABLE_RW; }
integer { yylval.sval = strdup(yytext); return INTEGER_RW; }
float   { yylval.sval = strdup(yytext); return FLOAT_RW; }
string  { yylval.sval = strdup(yytext); return STRING_RW; }
bool    { yylval.sval = strdup(yytext); return BOOL_RW; }
if  { yylval.sval = strdup(yytext); return IF_RW; }
then    { yylval.sval = strdup(yytext); return THEN_RW; }
else    { yylval.sval = strdup(yytext); return ELSE_RW; }
for { yylval.sval = strdup(yytext); return FOR_RW; }
return  { yylval.sval = strdup(yytext); return RETURN_RW; }

not { yylval.sval = strdup(yytext); return NOT_RW; }
true    { yylval.sval = strdup(yytext); return TRUE_RW; }
false   { yylval.sval = strdup(yytext); return FALSE_RW; }
":" { yylval.sval = strdup(yytext); return COLON; }
";" { yylval.sval = strdup(yytext); return SEMICOLON; }
"(" { yylval.sval = strdup(yytext); return L_PAREN; }
")" { yylval.sval = strdup(yytext); return R_PAREN; }
"," { yylval.sval = strdup(yytext); return COMMA; }
"[" { yylval.sval = strdup(yytext); return L_BRACKET; }
"]" { yylval.sval = strdup(yytext); return R_BRACKET; }
"_" { yylval.sval = strdup(yytext); return UNDERSCORE; }

":="    { yylval.sval = strdup(yytext); return ASSIGN_OP; }
"&" { yylval.sval = strdup(yytext); return AMPERSAND; }
"+" { yylval.sval = strdup(yytext); return PLUS; }
"-" { yylval.sval = strdup(yytext); return MINUS; }
"<" { yylval.sval = strdup(yytext); return LESS_THAN; }
"|" { yylval.sval = strdup(yytext); return PIPE; }
">="    { yylval.sval = strdup(yytext); return GREATER_EQUAL; }
"<="    { yylval.sval = strdup(yytext); return LESS_EQUAL; }
">" { yylval.sval = strdup(yytext); return GREATER_THAN; }
"=="    { yylval.sval = strdup(yytext); return EQUALS; }
"!="    { yylval.sval = strdup(yytext); return NOT_EQUAL; }
"*" { yylval.sval = strdup(yytext); return MULTIPLY; }
"/" { yylval.sval = strdup(yytext); return DIVIDE; }

"."		{ yylval.sval = strdup(yytext); return DOT; }

[0-9]+			    { yylval.ival = atoi(yytext); return INT; }
[0-9]+(\.[0-9]+)?	{ yylval.fval = atof(yytext); return FLOAT; }

\"[A-Za-z_]*\"   { yylval.sval = strdup(yytext); return STRING; }

[a-zA-Z0-9]+	{ yylval.sval = strdup(yytext); yylval.sval = strdup(yytext); return IDENTIFIER; }


%%



