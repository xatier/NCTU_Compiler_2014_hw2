%option noyywrap
%{
#include <stdio.h>
#include "header.h"
int linenumber;
symtab *lookup();
symtab *ptr;
void insertID();
void printSymTab();
/* You need to define for all tokens in C--, here are some examples */
#define RETURN        10
#define TYPEDEF       11
#define IF            12
#define ELSE          13
#define INT           14
#define FLOAT         15
#define FOR           16
#define STRUCT        17
#define UNION         18
#define VOID          19
#define WHILE         20
#define OP_PLUS       21
#define OP_MINUS      22
#define OP_MUL        23
#define OP_DIV        24
#define OP_LESS       25
#define OP_GREATER    26
#define OP_GEQUAL     27
#define OP_LEQUAL     28
#define OP_NOTEQ      29
#define OP_EQUAL      30
#define OP_ASSIGN     31
#define OP_OR         32
#define OP_AND        33
#define OP_NOT        34
#define MK_LPAREN     35
#define MK_RPAREN     36
#define MK_LBRACK     37
#define MK_RBRACK     38
#define MK_LBRACE     39
#define MK_RBRACE     40
#define ERROR         100

%}

letter   [A-Za-z]
digit    [0-9]
ID     {letter}({letter}|{digit}|"_")*
WS     [ \t]+
Int_constant {digit}+

/* You need to define the following RE's
Float_constant
String_constant
comment

*/

/*
{HP}{H}+{IS}?               { return I_CONSTANT; }
{NZ}{D}*{IS}?               { return I_CONSTANT; }
"0"{O}*{IS}?                { return I_CONSTANT; }
{CP}?"'"([^'\\\n]|{ES})+"'" { return I_CONSTANT; }

{D}+{E}{FS}?                { return F_CONSTANT; }
{D}*"."{D}+{E}?{FS}?        { return F_CONSTANT; }
{D}+"."{E}?{FS}?            { return F_CONSTANT; }
{HP}{H}+{P}{FS}?            { return F_CONSTANT; }
{HP}{H}*"."{H}+{P}{FS}?     { return F_CONSTANT; }
{HP}{H}+"."{P}{FS}?         { return F_CONSTANT; }
*/

RWReturn    "return"
RWTypedef   "typedef"
RWIf        "if"
RWElse      "else"
RWInt       "int"
RWFloat     "float"
RWFor       "for"
RWStruct    "struct"
RWUnion     "union"
RWVoid      "void"
RWWhile     "while"

/*
xatier: I think this might a referenct to C-style comments?
http://www.cs.man.ac.uk/~pjj/cs212/ex2_str_comm.html

xatier: A lex style to ANSI-C grammar
http://www.quut.com/c/ANSI-C-grammar-l.html
*/

OP_plus            "+"
OP_minus           "-"
OP_mul             "*"
OP_div             "/"

OP_less            "<"
OP_greater         ">"
OP_gequal          ">="
OP_lequal          "<="
OP_noteq           "!="
OP_equal           "=="

OP_assign          "="
OP_or              "||"
OP_and             "&&"
OP_not             "!"

/* Other operators appear here */


newline            "\n"

DL_lparen          "("
DL_rparen          ")"
DL_lbrack          "["
DL_rbrack          "]"
DL_lbrace          "{"
DL_rbrace          "}"
DL_comma           ","
DL_semicol         ";"
DL_dot             "."

/* Other separators appear here */

error              .

%%

{WS}               {}
{RWReturn}         {/* return RETURN; */ }
{RWTypedef}        {/* return TYPEDEF; */ }
{RWIf}             {/* return IF; */ }
{RWElse}           {/* return ELSE; */ }
{RWInt}            {/* return INT; */ }
{RWFloat}          {/* return FLOAT; */}
{RWFor}            {/* return FOR; */ }
{RWStruct}         {/* return STRUCT; */ }
{RWUnion}          {/* return UNION; */ }
{RWVoid}           {/* return VOID; */ }
{RWWhile}          {/* return WHILE; */ }
{Int_constant}     {/* return Int_constant*/ }
{ID}    {
            ptr = lookup(yytext);
            if (ptr == NULL)
                 insertID(yytext);
            else
                 ptr->counter++;
        }
{OP_plus}          {/* return OP_PLUS; */}
{OP_minus}         {/* return OP_MINUS; */}
{OP_mul}           {/* return OP_MUL; */}
{OP_div}           {/* return OP_DIV; */}
{OP_less}          {/* return OP_LESS; */}
{OP_greater}       {/* return OP_GREATER; */}
{OP_gequal}        {/* return OP_GEQUAL; */}
{OP_lequal}        {/* return OP_LEQUAL; */}
{OP_noteq}         {/* return OP_NOTEQ; */}
{OP_equal}         {/* return OP_EQUAL; */}
{OP_assign}        {/* return OP_ASSIGN; */}
{OP_or}            {/* return OP_OR; */}
{OP_and}           {/* return OP_AND; */}
{OP_not}           {/* return OP_NOT; */}
{DL_lparen}        {/* return MK_LPAREN; */}
{DL_rparen}        {/* return MK_RPAREN; */}
{DL_lbrack}        {/* return MK_LBRACK; */}
{DL_rbrack}        {/* return MK_RBRACK; */}
{DL_lbrace}        {/* return MK_LBRACE; */}
{DL_rbrace}        {/* return MK_RBRACE; */}
{DL_comma}         {}
{DL_semicol}       {}
{newline}          linenumber += 1;
{error}            ECHO;printf("\n");/*printf("ERR \n");*/     /* return ERROR; */


%%

main(int argc, char **argv)
{
 argc--; ++argv;
   if (argc > 0)
      yyin = fopen(argv[0], "r");
   else
      yyin = stdin;
   yylex();
   printSymTab();
}

