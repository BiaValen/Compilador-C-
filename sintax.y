%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    extern int linhano;
    extern int yylex();
    extern int yyparse();
    extern FILE* yyin;
    extern char* yytext;

    void yyerror(const char* s);

%}

%union {
    int ival;
    char* sval;
}


%token<ival> NUM
%token<sval> ID

/* Palavras-chave */
%token IF "if" 
%token ELSE "else" 
%token INT "int" 
%token RETURN "return" 
%token VOID "void" 
%token WHILE "while"

/* Operadores */
%token MAIS "+" 
%token SUB "-" 
%token MULT "*" 
%token DIV "/"
%token MENOR "<" 
%token MENORIG "<=" 
%token MAIOR ">" 
%token MAIORIG ">=" 
%token IGUALD "==" 
%token DIFF "!=" 
%token ATRIB "="

/* Pontuação */
%token PONTV ";" 
%token VIRG "," 
%token APAR "(" 
%token FPAR ")" 
%token ACOL "[" 
%token FCOL "]" 
%token ACHAV "{" 
%token FCHAV "}"
%token ERRO

/* Definição de precedência e associatividade */
%left MAIS SUB
%left MULT DIV

/* Definição para resolver o problema de ambiguidade de else */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%%
%%
