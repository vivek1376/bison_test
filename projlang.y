%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"

#define PRINT_INDTOKDEC(st, x) do { printIndentAndDecr(); printf("%s%s\n", st, x); } while (0)
#define PRINT_INDTOK(st, x) do { printIndent(); printf("%s%s\n", st, x); } while (0)



// Declare stuff from Flex that Bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;

/* extern char* yytext; */ 

void yyerror(const char *s);

int indent = 20;
void printIndent();
void printIndentAndDecr();

char str1[] = "identifier";
%}


%union {
  int ival;
  char *sval;
  Node* tnode;
}


%token <ival> INT
%token <sval> IDENTIFIER

%token <sval> PROGRAM_RW IS_RW BEGIN_RW END_RW GLOBAL_RW

%token <sval> PROCEDURE_RW VARIABLE_RW INTEGER_RW FLOAT_RW STRING_RW BOOL_RW IF_RW THEN_RW ELSE_RW FOR_RW RETURN_RW NOT_RW TRUE_RW FALSE_RW

%token <sval> COLON SEMICOLON L_PAREN R_PAREN COMMA L_BRACKET R_BRACKET UNDERSCORE ASSIGN_OP AMPERSAND PLUS MINUS LESS_THAN PIPE GREATER_EQUAL LESS_EQUAL GREATER_THAN EQUALS NOT_EQUAL MULTIPLY DIVIDE

%token <sval> DOT

%type <sval> colon identifier variable_rw integer_rw float_rw string_rw bool_rw

%type <sval> fullprogram program_header program_body

%type <sval> declarations declaration global variable_declaration type_mark statement assignment_statement destination

%type <tnode> expression

%type <ival> number
%%


fullprogram:
    program_header program_body DOT {
        PRINT_INDTOKDEC("fullprogram: ", $3);
    }
    ;

program_header:
    PROGRAM_RW
    identifier
    IS_RW { 
        PRINT_INDTOKDEC("program_header:", "");
    }
    ;

program_body:
    declarations
    BEGIN_RW
    statements
    END_RW PROGRAM_RW
    ;

declarations:
    %empty
    | declarations declaration
    ;

statements:
    %empty
    | statements statement
    ;

declaration:
    global
    variable_declaration
    SEMICOLON {}
    ;

statement:
    assignment_statement 
    SEMICOLON
    ;

assignment_statement:
    destination
    ASSIGN_OP
    expression
    ;

destination:
    identifier { printf("destination: %s\n", $1); }
    ;

expression:
    number { printf("number: %d\n", $1); }
    ;

number:
    INT { printf("%d\n", $1); }
    ;

global:
    %empty
    | GLOBAL_RW
    ;

variable_declaration:
    variable_rw
    identifier
    colon 
    type_mark { 
        indent -= 2;
        printIndent();
        printf("variable_declaration:\n");
        /* printf("vari..\n"); */
    }
    ;

variable_rw:    
    VARIABLE_RW {
        PRINT_INDTOK("variable_rw: ", $1);
    }
    ;

colon:
    COLON {
        PRINT_INDTOK("colon: ", $1);
    }
    ;
 
type_mark:
    integer_rw { PRINT_INDTOKDEC("type_mark:", ""); }
    | float_rw { PRINT_INDTOKDEC("type_mark:", ""); }
    | string_rw { PRINT_INDTOKDEC("type_mark:", ""); }
    | bool_rw { PRINT_INDTOKDEC("type_mark:", ""); }
    ;

integer_rw:
    INTEGER_RW { PRINT_INDTOKDEC("integer_rw: ", $1); }
    ;

float_rw:
    FLOAT_RW { PRINT_INDTOKDEC("float_rw: ", $1); }
    ;

string_rw:
    STRING_RW { PRINT_INDTOKDEC("string_rw: ", $1); }
    ;

bool_rw:
    BOOL_RW { PRINT_INDTOKDEC("bool_rw: ", $1); }
    ;

identifier:
    IDENTIFIER { PRINT_INDTOK("identifier: ", $1); }
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

  // if (printTreeFlag) printTree(stdout, syntaxTree);  // printTreeFlag is set by -p option
}


void yyerror(const char *s) {
  printf("parse error: %s\n", s);
  // might as well halt now:
  exit(-1);
}

void printIndent() {
  int i  = 0;

  for (i = 0; i < indent; i++)
    putchar(' ');
}

void printIndentAndDecr() {
  printIndent();
  indent -= 2;
}


