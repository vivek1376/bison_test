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
  char *sval;
  Node* tnode;
}


%token <ival> INT
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

%type <tnode> destination
%type <tnode> expression
%type <tnode> arithOp
%type <tnode> term
%type <tnode> factor
%type <tnode> relation
%type <tnode> number
%type <tnode> string
%%


fullprogram:
    program_header program_body DOT {
      $$ = createNode("program"); 
      addChild($$, $1); addChild($$, $2);  /* addChild($$, $3); */

      rootNode = $$;
    }
    ;

program_header:
    PROGRAM_RW
    identifier
    IS_RW { 
      $$ = createNode("program_header"); addChild($$, $1); addChild($$, $2); addChild($$, $3);
    }
    ;

program_body:
    declarations
    BEGIN_RW
    statements
    END_RW
    PROGRAM_RW {
      $$ = createNode("program_body"); addChild($$, $1); addChild($$, $2); addChild($$, $3);
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
    statement { $$ = createNode("statements"); addChildren_n($$, 2, $1, $2); }
    ;

declaration:
    global
    variable_declaration
    SEMICOLON {
      $$ = createNode("declaration");
      addChildren_n($$, 2, $1, $2); 
      addChild($$, $3);
    }
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
    IF_RW
    L_PAREN
    expression
    R_PAREN
    THEN_RW
    statements
    else_clause
    END_RW
    IF_RW { 
      $$ = createNode("if_statement"); addChild($$, $1); addChild($$, $2);
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
    %empty
    ;

return_statement:
    %empty  
    ;

else_clause:
    %empty { $$ = NULL; }
    | ELSE_RW
    statements { $$ = createNode("else_clause"); addChild($$, $1); addChild($$, $2); }
    ;

destination:
    identifier { $$ = createNode("destination"); addChild($$, $1); }
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
    arithOp PLUS relation
    | arithOp MINUS relation
    | relation { $$ = createNode("arithOp"); addChild($$, $1); }
    ;

relation:
    relation LESS_THAN term 
    | relation GREATER_EQUAL term 
    | relation LESS_EQUAL term 
    | relation GREATER_THAN term 
    | relation EQUALS term 
    | relation NOT_EQUAL term 
    | term { $$ = createNode("relation"); addChild($$, $1); }
    ;

term:
    term MULTIPLY factor 
    | term DIVIDE factor 
    | factor { $$ = createNode("term"); addChild($$, $1); }
    ;

factor:
    number { $$ = createNode("factor"); addChild($$, $1); }
    | string { $$ = createNode("factor"); addChild($$, $1); }
    | TRUE_RW { $$ = createNode("factor"); addChild($$, $1); }
    | FALSE_RW { $$ = createNode("factor"); addChild($$, $1); }
    ;

number:
    INT { 
      $$ = createNode("number");

      char *numSt = malloc(10 * sizeof *numSt);
      snprintf(numSt, 10, "%d", $1);
      
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
  printTree(rootNode, 0);
}


void yyerror(const char *s) {
  printf("parse error: %s\n", s);
  // might as well halt now:
  exit(-1);
}

/* void printIndent() { */
/*   int i  = 0; */

/*   for (i = 0; i < indent; i++) */
/*     putchar(' '); */
/* } */

inline void printIndent(int indent) {
  int i  = 0;

  for (i = 0; i < indent; i++)
    putchar(' ');
}
/* void printIndentAndDecr() { */
/*   printIndent(); */
/*   indent -= 2; */
/* } */

void printTree(Node *node, int indent) {
  if (!node) return;  // TODO redundant ?

  printIndent(indent);


  if (node->isTerminal)
    printf("🏉");

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
      break;
    }
  }
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
