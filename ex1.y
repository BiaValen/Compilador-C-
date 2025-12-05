%{

#include<stdio.h>
#include<stdlib.h>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
    int   ival;
    float fval;
}

%token<ival> T_INT
%token<fval> T_FLOAT
%token T_MAIS T_MENOS T_LPAR T_RPAR
%token T_NEWLINE

%left T_MAIS T_MENOS

%type<fval> exp
%type<fval> fator

%start calculation 

%%
calculation:
    | calculation line // Permite várias expressões/linhas
    ;

line: exp T_NEWLINE { printf("Resultado: %f\n", $1); } // <--- Nova regra 'line'
    | T_NEWLINE // Permite linhas vazias
    ;

exp : exp T_MAIS fator {$$ = $1 + $3;}
    | exp T_MENOS fator {$$ = $1 - $3;}
    | fator {$$ = $1;}
    ;
fator : T_LPAR exp T_RPAR {$$ = $2;}
      | T_INT {$$ = $1;}
      | T_FLOAT {$$ = $1;}
      ;
%%

int main(int argc, char **argv){
    if(argc > 1){
        yyin = fopen(argv[1], "r");
        if(yyin == NULL){
            fprintf(stderr, "Problema na leitura do arquivo!");
            return 1; // Erro de tipo 1
        }
    }
    else{
        yyin = fopen("flex/entrada.txt", "r");        
        if(yyin == NULL){
            fprintf(stderr, "Problema na leitura do arquivo!");
            return 1; // Erro de tipo 1
        }
    }

    do{
        yyparse(); // chamada ao parser
    }
    while(!feof(yyin));

    fclose(yyin);

    return 0; // Deu tudo certo

}

void yyerror(const char* s) {
	fprintf(stderr, "Parse error: %s\n", s);
	exit(1);
}