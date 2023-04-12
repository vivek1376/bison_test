
%token <ival> INT
%token <sval> STRING


%token PROGRAM_RW IS_RW VARIABLE_RW BEGIN_RW INTEGER_RW END_RW DOT


%%




full_program:
  program_header program_body DOT
  ;

program_header:
  PROGRAM_RW identifier IS_RW
  ;



%%


int main(int, char**) {
  // open a file handle to a particular file:
  FILE *myfile = fopen("a.snazzle.file", "r");
  // make sure it is valid:
  if (!myfile) {
    cout << "I can't open a.snazzle.file!" << endl;
    return -1;
  }
  // Set flex to read from it instead of defaulting to STDIN:
  yyin = myfile;
  // Parse through the input:
  yyparse();
}
