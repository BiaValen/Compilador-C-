%option noyywrap


%{
    //DEFINICOES E INCLUDES
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include "globals.h"
    #include "util.h"

    #include "sintax.tab.h"

    #define YY_DECL int yylex()

    //Variavel para contar as linhas (definida em util.c)
    extern int linha_atual;

%}


digito     [0-9]
letra      [a-zA-Z]
numero    {digito}({digito})*
id        {letra}({letra})*
novalinha \n
espacobranco [ \t\r]


%%

{novalinha} {linha_atual++;}
{espacobranco} {}
"else"       {return ELSE;}
"if"         {return IF;}
"int"        {return INT;}
"return"     {return RETURN;}
"void"	     {return VOID;}
"while"      {return WHILE;}


"+"          {return MAIS;}
"-"          {return SUB;}
"*"          {return MULT;}
"/"          {return DIV;}

"<"          {return MENOR;}
"<="	     {return MENORIG;}
">"	         {return MAIOR;}
">="	     {return MAIORIG;}
"=="         {return IGUALD;}
"!="         {return DIFF;}
"="          {return ATRIB;}


";"          {return PONTV;}
","          {return VIRG;}
"("          {return APAR;}
")"          {return FPAR;}
"["          {return ACOL;}
"]"          {return FCOL;}
"{"          {return ACHAV;}
"}"          {return FCHAV;}


{id}    {yylval.string = strdup(yytext); return ID;}
{numero} {yylval.val = atoi(yytext); return NUM;}

"/*"   { 
    char c;
    char p='\0';
    int inicComent = linha_atual;
    do{
        c = input();
        if (c == EOF){
            printf("ERRO LEXICO: Comentario nao terminado - LINHA: %d\n", inicComent);
            exit(EXIT_FAILURE);
        }
        if (c == '\n') 
            linha_atual++;
        if (p == '*' && c == '/') 
            break;
        p = c;
    } while (1);
    }

.       { printf("ERRO LEXICO: '%s' - LINHA: %d\n", yytext, linha_atual); exit(EXIT_FAILURE); }

%%
//CÓDIGO DO USUÁRIO

//extern FILE *yyin;
//int main(int argc, char *argv[]) {
//    if(argc > 1){
//        yyin = fopen(argv[1], "r");
//        if(yyin == NULL){
//            fprintf(stderr, "Problema na leitura do arquivo!");
//            return 1; // Erro de tipo 1
//        }
//    }
//   else{
//        yyin = fopen("testes/teste.cm", "r");        
//        if(yyin == NULL){
//            fprintf(stderr, "Problema na leitura do arquivo!");
//            return 1; // Erro de tipo 1
//       }
//    }
//
//    yylex();
//    return 0;
//}

//int yywrap() {
//    return 1;
//}





//flex lexer.l
//gcc lex.yy.c -o scanner
//.\scanner.exe teste.cm