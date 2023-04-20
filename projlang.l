%{
#include <stdio.h>
#include <string.h>
#include "tree.h"
#include "projlang.tab.h"  // to get the token types from Bison

void consume_comment();
%}


%%


[ \t\n]	;
"//".*	{}
"/*"  { consume_comment(); }
[pP][rR][oO][gG][rR][aA][mM]	{ yylval.sval = strdup(yytext); return PROGRAM_RW; }
[Ii][Ss]		{ yylval.sval = strdup(yytext); return IS_RW; }
[Bb][Ee][Gg][Ii][Nn] { yylval.sval = strdup(yytext); return BEGIN_RW; }
[Ee][Nn][Dd] { yylval.sval = strdup(yytext); return END_RW; }
[Gg][Ll][Oo][Bb][Aa][Ll] { yylval.sval = strdup(yytext); return GLOBAL_RW; }
[Pp][Rr][Oo][Cc][Ee][Dd][Uu][Rr][Ee] { yylval.sval = strdup(yytext); return PROCEDURE_RW; }
[Vv][Aa][Rr][Ii][Aa][Bb][Ll][Ee] { yylval.sval = strdup(yytext); return VARIABLE_RW; }
[Ii][Nn][Tt][Ee][Gg][Ee][Rr] { yylval.sval = strdup(yytext); return INTEGER_RW; }
[Ff][Ll][Oo][Aa][Tt] { yylval.sval = strdup(yytext); return FLOAT_RW; }
[Ss][Tt][Rr][Ii][Nn][Gg] { yylval.sval = strdup(yytext); return STRING_RW; }
[Bb][Oo][Oo][Ll] { yylval.sval = strdup(yytext); return BOOL_RW; }
[Ii][Ff]  { yylval.sval = strdup(yytext); return IF_RW; }
[Tt][Hh][Ee][Nn] { yylval.sval = strdup(yytext); return THEN_RW; }
[Ee][Ll][Ss][Ee]  { yylval.sval = strdup(yytext); return ELSE_RW; }
[Ff][Oo][Rr] { yylval.sval = strdup(yytext); return FOR_RW; }
[Rr][Ee][Tt][Uu][Rr][Nn] { yylval.sval = strdup(yytext); return RETURN_RW; }

[Nn][Oo][Tt] { yylval.sval = strdup(yytext); return NOT_RW; }
[Tt][Rr][Uu][Ee] { yylval.sval = strdup(yytext); return TRUE_RW; }
[Ff][Aa][Ll][Ss][Ee] { yylval.sval = strdup(yytext); return FALSE_RW; }
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

\"[^\"]*\"   { yylval.sval = strdup(yytext); return STRING; }

[a-zA-Z][a-zA-Z0-9_]*	{ yylval.sval = strdup(yytext); yylval.sval = strdup(yytext); return IDENTIFIER; }


%%


void consume_comment() {
    int c;

    /* EOF in lex is 0, which is different from
       the EOF macro in the C standard library */
    while ((c = input()) != 0) {
        /* printf("h1\n"); */
        /* putchar(c); */
        
        if (c == '*') {
            while ((c = input()) == '*') {
                /* putchar(c); */
                /* printf("h2\n"); */
            }

            if (c == 0) break;

            /* putchar(c); */

            if (c == '/') return;
        }
    }
}
