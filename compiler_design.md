## regular expression
negative look around
https://stackoverflow.com/a/23583655



## project


### lexer
use loop and switch or DFA

```
def scan:
	remove_whitespace
	process_cmnt
	switch (ch) :

```

### progress
- 8 march
Trying to figure out exisiting code. reverted changes and verified calling scan() multiple times returns a new token. Added changes back which has modified the `buildToken` fn. 


### C++
#### file handling concepts
when `ifstream` reaches end of file, does unget() work ?



### terms
recursive descent parser
translation scheme
syntax directed translator



## concepts
*check if understood*
recursive descent parser loop forever
- [ ] a predictive parser can't handle a left recursive grammar
- [ ] 2.5.1 - in AST each interior node represents an operator
- [ ] AST resemble parse trees to an extent
	in AST interior node represent programming constructs, in parse trees, interior nodes represent non-terminals
- [ ] symbol tables are DS for holding info about identifiers
- [x] for hashtable for words/ids? use the lexeme string as key
- [ ] concrete vs abstract syntax tree
- [ ] syntax vs semantics
- [ ] lexicalAnalysis slides: `class token : token_id`
- [ ] symbol table will be set or hashmap ?
- [ ] rewrite production rule ? see parser 2 slide page 15 ?
related to this ? - a non-LL(1) grammar must be transformed to an equivalent LL(1) grammar if it is to be parsed using a predictive parser.
- [ ] for `-1` should this be an integer token with negative value or a factor token ? token should be lexeme, should save separately ?
- [ ] top down parser cannot handle left recursive grammar
- [ ] does LL parser have backtracking ?
- [ ] function for each non-terminal ?
- [ ] left recursion 2.4.5 
- [ ] eliminate left recursion: immediate and multi-step
![[Pasted image 20230328143938.png]]
- [ ] in project description `expression` has left recursion ?
- [ ] left factoring : https://www.csd.uwo.ca/~mmorenom/CS447/Lectures/Syntax.html/node9.html
- [ ] while stmt can be expressed as (opcode, operands) ? where described, youtube vid?
- [ ] from course slides:
```
class nt_retType  
bool: returnCode  
end class  

class nt_retType : nt_retType_expr  
tokenType: *tt  
end class
```
- [ ] The machine has only four actions available: shift, reduce, accept, and error. A step of the parser is done as follows. Based on its current state, the parser decides if it needs a lookahead token to choose the action to be taken. https://docs.oracle.com/cd/E19504-01/802-5880/6i9k05dh1/index.html
- [ ] The job of a parser is to read an input stream and determine whether or not the input stream conforms to the grammar. https://www.cs.purdue.edu/homes/hosking/javacc/doc/lookahead.html
- [ ] parse tree vs AST
	https://stackoverflow.com/questions/5026517/whats-the-difference-between-parse-trees-and-abstract-syntax-trees-asts
	





### lex / bison
https://www.youtube.com/watch?v=54bo1qaHAfk

http://alumni.cs.ucr.edu/~lgao/teaching/flex.html
FLEX (Fast LEXical analyzer generator) is a tool for generating scanners.

https://web.stanford.edu/class/archive/cs/cs143/cs143.1128/handouts/050%20Flex%20In%20A%20Nutshell.pdf
yytext is a null­terminated string containing the text of the lexeme just
recognized as a token.

#### variables / symbols
see http://web.mit.edu/gnu/doc/html/bison_13.html
yylex
yylval


### parser implementation
- [ ] `scan_assume` 


#### C++🥎🏊🐰
- [ ] is new needed to return object from function 



## TODOs
march 11
change code structure to use main.cpp


- testing



fix conflict here:
commit b0ab80f8079c1e56ab707b8be935a23dd2622884 (HEAD -> master)
Author: Vivek Mehra <vivek.1376@gmail.com>
Date:   Mon Apr 17 19:47:33 2023 -0400

    complete name production



objective:
- **Flex/Bison**: Flex is a lexical analyzer and Bison is a LALR parser generator.  As part of this presentation you will be
    expected to implement your current project using these two tools to demonstrate to the class.  The presentation should cover
    the principle capabilities in the meta-languages for flex/bison as well as show a functioning lexer/parser of the class
    project language.  It should also show how programming additions can be added to the parser to create user developed actions
    to be performed during the parse.



there are 4 sections to my presentation
how these tools need to be used, they are supposed to be used in conjuction



#### bison
needs context free grammar
Any grammar expressed in BNF is a context-free grammar. The input to Bison is essentially machine-readable BNF.
LALR(1). In brief, this means that it must be possible to tell how to parse any portion of an input string with just a single [token](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS31) of look-ahead.

non-terminals / terminals, etc.

Each nonterminal symbol must have grammatical rules showing how it is made out of simpler constructs. For example, one kind of C statement is the `return` statement; this would be described with a grammar rule which reads informally as follows:

> A `statement' can be made of a `return' keyword, an `expression' and a `semicolon'.



The Bison [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20) reads a sequence of tokens as its input, and groups the tokens using the grammar rules. If the input is valid, the end result is that the entire [token](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS31) sequence reduces to a single [grouping](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS6) whose symbol is the grammar's start symbol.



**Bison grammar** file

non-terminals TOKEN uppercase

the naked semicolon, and the colon, are Bison punctuation used in every rule.

semantic action
semantic value

The output is a C source file that parses the language described by the grammar. This file is called a **Bison [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20)**. Keep in mind that the Bison utility and the Bison [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20) are two distinct programs: the Bison utility is a program whose output is the Bison [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20) that becomes part of your program.

The job of the Bison [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20) is to group tokens into groupings according to the grammar rules--for example, to build identifiers and operators into expressions. As it does this, it runs the actions for the grammar rules it uses.

The Bison [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20) calls the lexical analyzer each time it wants a new [token](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS31).

yyparse()  yylex()


##### [Stages in Using Bison](https://www.math.utah.edu/docs/info/bison_toc.html#SEC13)

The actual language-design process using Bison, from grammar specification to a working compiler or interpreter, has these parts:

1.  Formally specify the grammar in a form recognized by Bison (see section [Bison Grammar Files](https://www.math.utah.edu/docs/info/bison_6.html#SEC34)). For each grammatical rule in the language, describe the action that is to be taken when an instance of that rule is recognized. The action is described by a sequence of C statements.
2.  Write a lexical analyzer to process input and pass tokens to the [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20). The lexical analyzer may be written by hand in C (see section [The Lexical Analyzer Function `yylex`](https://www.math.utah.edu/docs/info/bison_7.html#SEC61)). It could also be produced using Lex, but the use of Lex is not discussed in this manual.
3.  Write a controlling function that calls the Bison-produced [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20).
4.  Write error-reporting routines.





**Bison grammar file**. The general form of a Bison grammar file is as follows:

%{
C declarations
%}

Bison declarations

%%
Grammar rules
%%
Additional C code


To turn this source code as written into a runnable program, you must follow these steps:

1.  Run Bison on the grammar to produce the [parser](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS20).
2.  Compile the code output by Bison, as well as any other source files.
3.  Link the object files to produce the finished product.

The C declarations may define types and variables used in the actions. You can also use preprocessor commands to define macros used there, and use `#include` to include header files that do any of these things.


The Bison declarations declare the names of the terminal and nonterminal symbols, and may also describe operator precedence and the data types of semantic values of various symbols.

The grammar rules define how to construct each nonterminal symbol from its parts.

The additional C code can contain any C code you want to use. Often the definition of the lexical analyzer `yylex` goes here, plus subroutines called by the actions in the grammar rules. In a simple program, all the rest of the program can go here.


a table of Bison constructs, variables and macros that are useful in actions.

`$$'

Acts like a variable that contains the semantic value for the [grouping](https://www.math.utah.edu/docs/info/bison_14.html#GLOSS6) made by the current rule. See section [Actions](https://www.math.utah.edu/docs/info/bison_6.html#SEC46).

`$n'

Acts like a variable that contains the semantic value for the nth component of the current rule. See section [Actions](https://www.math.utah.edu/docs/info/bison_6.html#SEC46).

The `%union` declaration specifies the entire collection of possible data types for semantic values. The keyword `%union` is followed by a pair of braces containing the same thing that goes inside a `union` in C.

For example:

%union {
  double val;
  symrec *tptr;
}