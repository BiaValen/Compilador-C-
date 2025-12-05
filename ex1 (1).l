%option noyywrap

%{
#include <stdio.h>
#include <stdlib.h>

#define YY_DECL int yylex()

#include "ex1.tab.h"
%}

%%
[ \t] ; // ignorar espaços em branco
[0-9]+\.[0-9]+ {yylval.fval = atof(yytext); return T_FLOAT;}
[0-9]+ {yylval.ival = atoi(yytext); return T_INT;}
"(" {return T_LPAR;}
")" {return T_RPAR;}
"+" {return T_MAIS;}
"-" {return T_MENOS;}
"\n" {return T_NEWLINE;}
%%