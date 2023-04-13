%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



// Declare stuff from Flex that Bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;
 
void yyerror(const char *s);

int indent = 0;
void printSpaces(int);

%}


%union {
  int ival;
  char *sval;
}


%token <ival> INT
%token <sval> STRING

%token <sval> PROGRAM_RW IS_RW VARIABLE_RW BEGIN_RW INTEGER_RW END_RW DOT

%type <sval> fullprogram program_header program_body identifier

%%


fullprogram:
    program_header program_body DOT { indent++; printf("found DOT\n"); }
    ;

program_header:
    PROGRAM_RW
    identifier { printSpaces(++indent); printf("identifier is : %s\n", $2); }
    IS_RW
    ;

program_body:
    BEGIN_RW
    END_RW PROGRAM_RW
    ;

identifier:
    STRING
    ;


%%


int main(int, char**) {
  // open a file handle to a particular file:
  FILE *myfile = fopen("testparseprog.src", "r");
  // make sure it is valid:
  if (!myfile) {
    printf("can't open file!\n");
    return -1;
  }

  // Set flex to read from it instead of defaulting to STDIN:
  yyin = myfile;

  // Parse through the input:
  yyparse();
}


void yyerror(const char *s) {
  printf("parse error: %s\n", s);
  // might as well halt now:
  exit(-1);
}

void printSpaces(int indent) {
  int i  = 0;

  for (i = 0; i < indent; i++)
    putchar(' ');
}
