%option noyywrap

//DEFINIÇÕES
%{
    
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <globals.h>
    #include <util.h>
    #include <scan.h>
    #include <ctype.h>

    static int yylex(void);

    #include "ex1.tab.h"

    //Variavel para contar as linhas
    int linhano = 1;
%}

//
digito     [0-9]
letra      [a-zA-Z]
numero    {digito}+
id        {letra}({letra}|{digito})*
novalinha \n
espacobranco [ \t\r]

//REGRAS
%%

//palavra reservada
"else"       {return ELSE;}
"if"         {return IF;}
"int"        {return INT;}
"return"     {return RETURN;}
"void"	     {return VOID;}
"while"      {return WHILE;}

//operadores
"+"          {return MAIS;}
"-"          {return SUB;}
"*"          {return MULT;}
"/"          {return DIV;}

"<"          {return MENOR;}
"<="	     {return MENORIG;}
">"	         {return MAIOR;}
">="	     {return MAIORIG;}
"=="         {return IGUALD;}
"!="         { return DIFF;}
"="          {return ATRIB;}

//delimitadores
";"          {return PONTV;}
","          {return VIRG;}
"("          {return APAR;}
")"          {return FPAR;}
"["          {return ACOL;}
"]"          {return FCOL;}
"{"          {return ACHAV;}
"}"          {return FCHAV;}


{numero} {return NUM;}

//Identificadores
{id}    {return ID;}

{novalinha} {linhano++;}
{espacobranco} ; //ignorar espacos em branco

"/*"   { 
    char c;
    char p='\0';
    do{
        c = input(); //Funcao do flex que puxa o proximo caracter
        if (c == EOF){
            printf("ERRO LEXICO: Comentario nao terminado LINHA: %d\n", linhano);
            break;
        }
        if (c == '\n') 
            linhano++;
        if (p == '*' && c == '/') 
            break;
        p = c;
    } while (1);
    }
.       { printf("ERRO LEXICO: '%s' LINHA: %d\n", yytext, linhano); }

%%


//CÓDIGO DO USUÁRIO

extern FILE *yyin;
int main(int argc, char *argv[]) {
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if(yyin == NULL){
            fprintf(stderr, "Problema na leitura do arquivo!");
            return 1; // Erro de tipo 1
        }
    }
    else{
        yyin = fopen("testes/teste.cm", "r");        
        if(yyin == NULL){
            fprintf(stderr, "Problema na leitura do arquivo!");
            return 1; // Erro de tipo 1
        }
    }

    yylex();
    return 0;
}

int yywrap() {
    return 1;
}





//flex lexer.l
//gcc lex.yy.c -o scanner
//.\scanner.exe teste.cm