%option noyywrap

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>

    // Tokens (sem precisar do ex1.tab.h)
    #define ELSE 258
    #define IF 259
    #define INT 260
    #define RETURN 261
    #define VOID 262
    #define WHILE 263
    #define MAIS 264
    #define SUB 265
    #define MULT 266
    #define DIV 267
    #define MENOR 268
    #define MENORIG 269
    #define MAIOR 270
    #define MAIORIG 271
    #define IGUALD 272
    #define DIFF 273
    #define ATRIB 274
    #define PONTV 275
    #define VIRG 276
    #define APAR 277
    #define FPAR 278
    #define ACOL 279
    #define FCOL 280
    #define ACHAV 281
    #define FCHAV 282
    #define NUM 283
    #define ID 284

    int linhano = 1;
%}

digito     [0-9]
letra      [a-zA-Z]
numero    {digito}({digito})*
id        {letra}({letra})*
novalinha \n
espacobranco [ \t\r]

%%

"else"       { printf("TOKEN: ELSE\n"); return ELSE; }
"if"         { printf("TOKEN: IF\n"); return IF; }
"int"        { printf("TOKEN: INT\n"); return INT; }
"return"     { printf("TOKEN: RETURN\n"); return RETURN; }
"void"       { printf("TOKEN: VOID\n"); return VOID; }
"while"      { printf("TOKEN: WHILE\n"); return WHILE; }

"+"          { printf("TOKEN: MAIS\n"); return MAIS; }
"-"          { printf("TOKEN: SUB\n"); return SUB; }
"*"          { printf("TOKEN: MULT\n"); return MULT; }
"/"          { printf("TOKEN: DIV\n"); return DIV; }

"<"          { printf("TOKEN: MENOR\n"); return MENOR; }
"<="         { printf("TOKEN: MENORIG\n"); return MENORIG; }
">"          { printf("TOKEN: MAIOR\n"); return MAIOR; }
">="         { printf("TOKEN: MAIORIG\n"); return MAIORIG; }
"=="         { printf("TOKEN: IGUALD\n"); return IGUALD; }
"!="         { printf("TOKEN: DIFF\n"); return DIFF; }
"="          { printf("TOKEN: ATRIB\n"); return ATRIB; }

";"          { printf("TOKEN: PONTV\n"); return PONTV; }
","          { printf("TOKEN: VIRG\n"); return VIRG; }
"("          { printf("TOKEN: APAR\n"); return APAR; }
")"          { printf("TOKEN: FPAR\n"); return FPAR; }
"["          { printf("TOKEN: ACOL\n"); return ACOL; }
"]"          { printf("TOKEN: FCOL\n"); return FCOL; }
"{"          { printf("TOKEN: ACHAV\n"); return ACHAV; }
"}"          { printf("TOKEN: FCHAV\n"); return FCHAV; }

{numero}     { printf("TOKEN: NUM (%s)\n", yytext); return NUM; }
{id}         { printf("TOKEN: ID (%s)\n", yytext); return ID; }

{novalinha}  { linhano++; }
{espacobranco} ; 

"/*"   { 
    char c;
    char p='\0';
    int inicComent = linhano;
    do{
        c = input();
        if (c == 0){
            printf("ERRO LEXICO: Comentario nao terminado - LINHA: %d\n", inicComent);
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

extern FILE *yyin;

int main(int argc, char *argv[]) {
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if(yyin == NULL){
            fprintf(stderr, "Problema na leitura do arquivo!\n");
            return 1;
        }
    }
    else{
        yyin = fopen("testes/teste.cm", "r");        
        if(yyin == NULL){
            fprintf(stderr, "Problema na leitura do arquivo!\n");
            return 1;
        }
    }

    printf("=== ANALISE LEXICA ===\n");
    
    int token;
    while((token = yylex()) != 0) {
        // Processa cada token até o fim do arquivo
    }
    
    printf("\n=== FIM DA ANALISE ===\n");
    
    return 0;
}
