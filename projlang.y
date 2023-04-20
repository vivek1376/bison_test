%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tree.h"

/* #define PRINT_INDTOKDEC(st, x) do { printIndentAndDecr(); printf("%s%s\n", st, x); } while (0) */
/* #define PRINT_INDTOK(st, x) do { printIndent(); printf("%s%s\n", st, x); } while (0) */



// Declare stuff from Flex that Bison needs to know about:
extern int yylex();
extern int yyparse();
extern FILE *yyin;

/* extern char* yytext; */ 

void yyerror(const char *s);

int indent = 20;
/* void printIndent(); */
void printIndent(int indent);
/* void printIndentAndDecr(); */

char str1[] = "identifier";

Node *rootNode;
%}


%union {
  int ival;
  float fval;
  char *sval;
  Node* tnode;
}


%token <ival> INT
%token <fval> FLOAT
%token <sval> STRING
%token <sval> IDENTIFIER

%token <sval> PROGRAM_RW IS_RW BEGIN_RW END_RW GLOBAL_RW

%token <sval> PROCEDURE_RW VARIABLE_RW INTEGER_RW FLOAT_RW STRING_RW BOOL_RW IF_RW THEN_RW ELSE_RW FOR_RW RETURN_RW NOT_RW TRUE_RW FALSE_RW

%token <sval> COLON SEMICOLON L_PAREN R_PAREN COMMA L_BRACKET R_BRACKET UNDERSCORE ASSIGN_OP AMPERSAND PLUS MINUS LESS_THAN PIPE GREATER_EQUAL LESS_EQUAL GREATER_THAN EQUALS NOT_EQUAL MULTIPLY DIVIDE

%token <sval> DOT

%type <tnode> identifier
%type <tnode> fullprogram 
%type <tnode> program_header
%type <tnode> program_body

%type <tnode> declarations 
%type <tnode> declaration 
%type <tnode> procedure_declaration 
%type <tnode> procedure_header
%type <tnode> procedure_body
%type <tnode> procedure_call
%type <tnode> argument_list
%type <tnode> parameter_list
%type <tnode> parameter
%type <tnode> global 
%type <tnode> variable_declaration
%type <tnode> type_mark

%type <tnode> statements
%type <tnode> statement

%type <tnode> assignment_statement
%type <tnode> if_statement
%type <tnode> loop_statement
%type <tnode> return_statement
%type <tnode> else_clause
%type <tnode> bound

%type <tnode> destination
%type <tnode> expression
%type <tnode> arithOp
%type <tnode> term
%type <tnode> factor
%type <tnode> relation
%type <tnode> number
%type <tnode> name
%type <tnode> string
%%


fullprogram:
    program_header program_body DOT {
      $$ = createNode("program"); 
      addChild($$, $1);
      addChild($$, $2);   
      addChild($$, $3); 

      rootNode = $$;
    }
    ;

program_header:
    PROGRAM_RW identifier IS_RW {       
      $$ = createNode("program_header"); 
      addChild($$, $1);
      addChild($$, $2);
      addChild($$, $3);
    }
    ;

program_body:
    declarations BEGIN_RW statements END_RW PROGRAM_RW { $$ = createNode("program_body"); addChild($$, $1); addChild($$, $2); addChild($$, $3);
      addChild($$, $4);
      addChild($$, $5);
    }
    ;

declarations:
    %empty { $$ = NULL; }
    | declarations declaration {
      $$ = createNode("declarations"); addChild($$, $1); addChild($$, $2);
    }
    ;

statements:
    %empty { $$ = NULL; }
    | statements
    statement { $$ = createNode("statements"); addChild($$, $1); addChild($$, $2); }
    ;

declaration:
    global
    variable_declaration
    SEMICOLON {
      $$ = createNode("declaration");
      addChildren_n($$, 2, $1, $2); 
      addChild($$, $3);
    }
    | global
    procedure_declaration
    SEMICOLON {
      $$ = createNode("declaration");
      addChildren_n($$, 2, $1, $2); 
      addChild($$, $3);
    } 
    ;

procedure_declaration:
    procedure_header
    procedure_body { $$ = createNode("procedure_declaration"); addChild($$, $1); addChild($$, $2); }
    ;

procedure_header:
    PROCEDURE_RW identifier COLON type_mark L_PAREN R_PAREN { $$ = createNode("procedure_header");
      addChild($$, $1); addChild($$, $2); addChild($$, $3); addChild($$, $4); 
      addChild($$, $5); addChild($$, $6); }
    | PROCEDURE_RW identifier COLON type_mark L_PAREN parameter_list R_PAREN {
      $$ = createNode("procedure_header");
      addChild($$, $1); addChild($$, $2); addChild($$, $3); addChild($$, $4); addChild($$, $5); 
      addChild($$, $6); addChild($$, $7); 
    }
    ;

parameter_list:
    parameter_list COMMA parameter { $$ = createNode("parameter_list"); addChild($$, $1);
      addChild($$, $2); addChild($$, $3); }
    | parameter { $$ = createNode("parameter_list"); addChild($$, $1); }
    ;

parameter:
    variable_declaration { $$ = createNode("parameter"); addChild($$, $1); }
    ;

procedure_body:
    declarations BEGIN_RW statements END_RW PROCEDURE_RW { $$ = createNode("procedure_body");
      addChild($$, $1); addChild($$, $2); addChild($$, $3); addChild($$, $4); addChild($$, $5); 
    }
    ;

procedure_call:
    identifier L_PAREN R_PAREN { $$ = createNode("procedure_call"); addChild($$, $1);
      addChild($$, $2); addChild($$, $3); }
      | identifier L_PAREN argument_list R_PAREN { $$ = createNode("procedure_call"); 
      addChild($$, $1);
      addChild($$, $2); 
      addChild($$, $3); 
      addChild($$, $4); 
    }
    ;

argument_list:
    argument_list COMMA expression { $$ = createNode("argument_list"); addChild($$, $1);
      addChild($$, $2); addChild($$, $3); }
    | expression { $$ = createNode("argument_list"); addChild($$, $1); }
    ;

statement:
    assignment_statement 
    SEMICOLON { $$ = createNode("statement"); addChild($$, $1); addChild($$, $2); }
    | if_statement
    SEMICOLON { $$ = createNode("statement"); addChild($$, $1); addChild($$, $2); }
    | loop_statement
    SEMICOLON { $$ = createNode("statement"); addChild($$, $1); addChild($$, $2); }
    | return_statement
    SEMICOLON { $$ = createNode("statement"); addChild($$, $1); addChild($$, $2); }
    ;

assignment_statement:
    destination
    ASSIGN_OP
    expression {
      $$ = createNode("assignment_statement"); addChild($$, $1);
      addChild($$, $2);
      addChild($$, $3);
    }
    ;

if_statement:
    IF_RW L_PAREN expression R_PAREN THEN_RW statements else_clause END_RW IF_RW {
      $$ = createNode("if_statement");
      addChild($$, $1);
      addChild($$, $2);
      addChild($$, $3);
      addChild($$, $4);
      addChild($$, $5);
      addChild($$, $6);
      addChild($$, $7);
      addChild($$, $8);
      addChild($$, $9);
    }
    ;

loop_statement:
    FOR_RW L_PAREN assignment_statement SEMICOLON expression R_PAREN statements END_RW FOR_RW {
      $$ = createNode("loop_statement");
      addChild($$, $1);
      addChild($$, $2);
      addChild($$, $3);
      addChild($$, $4);
      addChild($$, $5);
      addChild($$, $6);
      addChild($$, $7);
      addChild($$, $8);
      addChild($$, $9);
    }
    ;

return_statement:
    RETURN_RW expression { 
      $$ = createNode("return_statement"); 
      addChild($$, $1); 
    }
    ;

else_clause:
    %empty { $$ = NULL; }
    | ELSE_RW statements { $$ = createNode("else_clause"); addChild($$, $1); addChild($$, $2); }
    ;

destination:
    identifier { $$ = createNode("destination"); addChild($$, $1); }
    | identifier L_BRACKET expression R_BRACKET { 
      $$ = createNode("destination"); 
      addChild($$, $1); 
      addChild($$, $2); 
      addChild($$, $3); 
      addChild($$, $4); 
    }
    ;

expression:
    expression AMPERSAND arithOp { 
      $$ = createNode("expression"); 
      addChild($$, $1);
      addChild($$, $2); 
      addChild($$, $3); 
    }
    | expression PIPE arithOp { 
      $$ = createNode("expression"); 
      addChild($$, $1);
      addChild($$, $2); 
      addChild($$, $3); 
    }
    | NOT_RW arithOp { $$ = createNode("expression"); addChild($$, $1); addChild($$, $2); }
    | arithOp { $$ = createNode("expression"); addChild($$, $1); }
    ;

arithOp:
    arithOp PLUS relation {
      $$ = createNode("arithOp"); 
      addChild($$, $1); 
      addChild($$, $2); 
      addChild($$, $3); 
    }
    | arithOp MINUS relation {
      $$ = createNode("arithOp"); 
      addChild($$, $1); 
      addChild($$, $2); 
      addChild($$, $3); 
    }
    | relation { $$ = createNode("arithOp"); addChild($$, $1); }
    ;

relation:
    relation LESS_THAN term { $$ = createNode("relation"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    }
    | relation GREATER_EQUAL term { $$ = createNode("relation"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    } 
    | relation LESS_EQUAL term { $$ = createNode("relation"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    } 
    | relation GREATER_THAN term { $$ = createNode("relation"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    } 
    | relation EQUALS term { $$ = createNode("relation"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    } 
    | relation NOT_EQUAL term { $$ = createNode("relation"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    } 
    | term { $$ = createNode("relation"); addChild($$, $1); }
    ;

term:
    term MULTIPLY factor { $$ = createNode("term"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    }
    | term DIVIDE factor { $$ = createNode("term"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); 
    } 
    | factor { $$ = createNode("term"); addChild($$, $1); }
    ;

factor:
    L_PAREN expression R_PAREN { $$ = createNode("factor"); addChild($$, $1);
      addChild($$, $2); addChild($$, $3); }
    | procedure_call { $$ = createNode("factor"); addChild($$, $1); }
    | name { $$ = createNode("factor"); addChild($$, $1); } 
    | MINUS name { $$ = createNode("factor"); addChild($$, $1); addChild($$, $2); }
    | number { $$ = createNode("factor"); addChild($$, $1); }
    | MINUS number { $$ = createNode("factor"); addChild($$, $1); addChild($$, $2); }
    | string { $$ = createNode("factor"); addChild($$, $1); }
    | TRUE_RW { $$ = createNode("factor"); addChild($$, $1); }
    | FALSE_RW { $$ = createNode("factor"); addChild($$, $1); }
    ;

name:
    identifier { $$ = createNode("name"); addChild($$, $1); }
    | identifier L_BRACKET expression R_BRACKET { $$ = createNode("relation"); addChild($$, $1); 
      addChild($$, $2); addChild($$, $3); addChild($$, $4); 
    } 
    ;

number:
    INT { 
      $$ = createNode("number");

      const int numlen = 10;
      char *numSt = malloc(numlen * sizeof *numSt);
      snprintf(numSt, numlen, "%d", $1);
      
      addChild($$, numSt);
    }
    | FLOAT { 
      $$ = createNode("number");

      const int numlen = 10;
      char *numSt = malloc(numlen * sizeof *numSt);
      snprintf(numSt, numlen, "%f", $1);
      
      addChild($$, numSt);
    }
    ;

string:
    STRING { $$ = createNode("string"); addChild($$, $1); }
    ;

global:
    %empty { $$ = NULL;  /* TODO explain why not create node and then add child ? */ }
    | GLOBAL_RW { $$ = createNode($1); }
    ;

variable_declaration:
    VARIABLE_RW 
    identifier
    COLON 
    type_mark { 
      $$ = createNode("variable_declaration"); addChild($$, $1); addChild($$, $2); 
      addChild($$, $3); 
      addChild($$, $4); 
    }
    | VARIABLE_RW  identifier COLON  type_mark L_BRACKET bound R_BRACKET {  $$ = createNode("variable_declaration"); addChild($$, $1); addChild($$, $2); 
      addChild($$, $3); 
      addChild($$, $4); 
      addChild($$, $5); 
      addChild($$, $6); 
      addChild($$, $7); 
    } 
    ;

bound:
     number { $$ = createNode("bound"); addChild($$, $1); }
     ;

type_mark:
    INTEGER_RW { $$ = createNode("type_mark"); addChild($$, $1); }
    | FLOAT_RW { $$ = createNode($1); }
    | STRING_RW { $$ = createNode($1); }
    | BOOL_RW { $$ = createNode($1); }
    ;

identifier:
    IDENTIFIER { $$ = createNode("identifier"); addChild($$, $1); }
    ;

%%


int main(int, char**) {

  // open a file handle to a particular file:
  FILE *myfile = fopen("testparseprog.src", "r");

  // make sure it is valid
  if (!myfile) {
    printf("can't open file!\n");
    return -1;
  }

  // Set flex to read from it instead of defaulting to STDIN
  yyin = myfile;

  // Parse through the input
  yyparse();

  printTree(rootNode, 0);
}


void yyerror(const char *s) {
  printf("parse error: %s\n", s);
  // might as well halt now:
  exit(-1);
}


inline void printIndent(int indent) {
  int i  = 0;

  for (i = 0; i < indent; i++)
    putchar(' ');
}


void printTree(Node *node, int indent) {
  if (!node) return;  // TODO redundant ?

  printIndent(indent);


  if (node->isTerminal)
    printf("🔔");
    /* printf("🏉"); */

  printf("%s\n", node->st);

  int i;

  for (i = 0; i < MAX_CHILDREN; i++) {
    if (node->children[i])
      printTree(node->children[i], indent + 2);
    else
      break;
  }
  
}


Node* createNode(char *p_st) {
  Node *n = malloc(sizeof *n);
  n->st = p_st;
  n->type = DEFAULTNODE;
  n->isTerminal = 0;

  int i;
  
  // set children NULL
  for (i = 0; i < MAX_CHILDREN; i++) {
    n->children[i] = NULL;
  }

  return n;
}


void addChildn(Node *n, Node *child) {

  if (!child) return;

  /* Node *temp; */
  int i = 0;

  for (i = 0; i < MAX_CHILDREN; i++) {
    if (n->children[i] == NULL) {
      n->children[i] = child;
      return;
    }
  }

  // we have exceeded MAX_CHILDREN limit
  assert(0);
}


void addChilds(Node *n, char *st) {

  int i = 0;
  Node *child;

  for (i = 0; i < MAX_CHILDREN; i++) {
    if (n->children[i] == NULL) {

      child = createNode(st);
      child->isTerminal = 1;

      n->children[i] = child;
      return;
    }
  }

  // we have exceeded MAX_CHILDREN limit
  assert(0);
}


// variadic functions
void addChildren_n(Node *n, int num, ...) {
  va_list valist;

  va_start(valist, num);

  int i;
  for (i = 0; i < num; i++) {
    addChildn(n, va_arg(valist, Node*));
  }
}


void addChildren_s(Node *n, int num, ...) {
  va_list valist;

  va_start(valist, num);

  int i;
  for (i = 0; i < num; i++) {
    addChilds(n, va_arg(valist, char*));
  }
}
