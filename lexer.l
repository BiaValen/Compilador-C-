%option noyywrap


%{
    //DEFINICOES E INCLUDES
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>

    #include "sintax.tab.h"

    #define YY_DECL int yylex()

    //Variavel para contar as linhas
    int linhano = 1;

%}


digito     [0-9]
letra      [a-zA-Z]
numero    {digito}({digito})*
id        {letra}({letra})*
novalinha \n
espacobranco [ \t\r]


%%

{novalinha} {linhano++;}
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


{id}    {yylval.sval = strdup(yytext); return ID;}
{numero} {yylval.ival = atoi(yytext); return NUM;}

"/*"   { 
    char c;
    char p='\0';
    int inicComent = linhano;
    do{
        c = input();
        if (c == EOF){
            printf("ERRO LEXICO: Comentario nao terminado - LINHA: %d\n", inicComent);
            exit(EXIT_FAILURE);
        }
        if (c == '\n') 
            linhano++;
        if (p == '*' && c == '/') 
            break;
        p = c;
    } while (1);
    }

.       { printf("ERRO LEXICO: '%s' - LINHA: %d\n", yytext, linhano); exit(EXIT_FAILURE); }

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