%define parse.error verbose
%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "tabelaSimbolos.h"

    /* Variáveis para controlar o escopo atual */
    char * escopo = "global"; 
    char * idTipo = "int";   

    /* Contador de posição de memória */
    int localizacao = 0;
 
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


%start program

%%

    program:
        declaration_list 
    ;

    declaration_list:
        declaration_list declaration
        | declaration
    ;

    declaration:
        var_declaration
        | fun_declaration
    ;

    var_declaration:
        type_specifier ID PONTV
        { 
            insere_ts($2, linhano, localizacao++, escopo, "var", idTipo); 
        }
        | type_specifier ID ACOL NUM FCOL PONTV 
        {
            insere_ts($2, linhano, localizacao++, escopo, "vet", idTipo);
            localizacao += $4 - 1;
        }
    ;

    type_specifier:
        INT { idTipo = "int"; }
        | VOID { idTipo = "void"; }
    ;

    fun_declaration:
        type_specifier ID 
        { 
         /* Insere a função no escopo GLOBAL antes de entrar nela */
         insere_ts($2, linhano, 0, "global", "fun", idTipo);
         
         /* Muda o escopo para o nome da função */
         escopo = $2; 
         
         /* Zera localizador de memória para as variáveis locais */
         localizacao = 0; 
        }
        APAR params FPAR compound_stmt
        {
         /* Ao terminar a função, volta para o escopo global */
         escopo = "global";
        }
    ;

    params:
        param_list
        | VOID
    ;

    param_list:
        param_list VIRG param
        | param
    ;

    param:
        type_specifier ID
        { 
         insere_ts($2, linhano, localizacao++, escopo, "var", idTipo); 
        }
        | type_specifier ID ACOL FCOL
        { 
         insere_ts($2, linhano, localizacao++, escopo, "vet", idTipo); 
        }
    ;

    compound_stmt:
        ACHAV local_declarations statement_list FCHAV
    ;

    local_declarations:
        local_declarations var_declaration
        | empty
    ;

    statement_list:
        statement_list statement
        | empty
    ;

    statement:
        expression_stmt
        | compound_stmt
        | selection_stmt
        | iteration_stmt
        | return_stmt
    ;

    expression_stmt:
        expression PONTV
        | PONTV
    ;

    selection_stmt:
        IF APAR expression FPAR statement %prec LOWER_THAN_ELSE
        | IF APAR expression FPAR statement ELSE statement
    ;

    iteration_stmt:
        WHILE APAR expression FPAR statement
    ;

    return_stmt:
        RETURN PONTV
        | RETURN expression PONTV
    ;

    expression:
        var ATRIB expression
        | simple_expression
    ;

    var:
        ID
        { 
        /* Apenas verifica se foi declarada, não insere */
        verifica_declarada($1, escopo, linhano);
        }
        | ID ACOL expression FCOL
        {
        /* Verifica se array foi declarado */
        verifica_declarada($1, escopo, linhano);
        }
    ;
    
    simple_expression:
        additive_expression relop additive_expression
        | additive_expression
    ;

    relop:
        MENORIG | MENOR | MAIORIG | MAIOR | IGUALD | DIFF
    ;

    additive_expression:
        additive_expression addop term 
        | term
    ;
    
    addop:
        MAIS 
        | SUB 
    ;

    term:
        term mulop factor
        | factor
    ;

    mulop:
        MULT
        | DIV
    ;

    factor:
        APAR expression FPAR
        | var
        | call
        | NUM
    ;

    call: 
        ID APAR args FPAR
        {
        /* Verifica se função foi declarada */
        verifica_funcao_declarada($1, escopo, linhano);
        }
    ;
    
    args:
        arg_list
        | empty
    ;

    arg_list:
        arg_list VIRG expression
        | expression
    ;

    empty:
        /* vazio */
    ;

%%

/* Função de Erro */
void yyerror(const char *s) {
    // Extrair apenas o token esperado da mensagem
    const char *esperado = strstr(s, "expecting ");
    
    fprintf(stderr, "\nERRO SINTATICO:");
    fprintf(stderr, " token inesperado '%s',", yytext);
    
    if (esperado) {
        // Pular "expecting " (10 caracteres)
        fprintf(stderr, "  esperado '%s' - LINHA: %d", esperado + 10, linhano);
    } else {
        fprintf(stderr, "  %s\n", s);
    }
    
    exit(EXIT_FAILURE);
}


int main(int argc, char *argv[]) {
    extern FILE *yyin;
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
    
    criaTabela();
    
    /* Parser */
    int result = yyparse();

    printf("\nTABELA DE SIMBOLOS:\n");
    print_ts(stdout); 

    liberaTabela();
    
    return 0;
}