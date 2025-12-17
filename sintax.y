%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "globals.h"
    #include "util.h"
    #include "codegen.h"
    #include "tabelaSimbolos.h"

    /* Variáveis para controlar o escopo atual */
    char * escopo = "global"; 
    char * idTipo = "int";   

    /* Contador de posição de memória */
    int localizacao = 0;
    int ContadorBloco = 1;

    char escopoAnterior[50];
 
    extern int linha_atual;
    extern int yylex();
    extern char* yytext;
    TreeNode * savedTree; /* Raiz da arvore final */

    void yyerror(const char* s); 

    /* Função auxiliar para adicionar irmão na lista */
    TreeNode * addSibling(TreeNode * t, TreeNode * s) {
        if (t != NULL) {
            TreeNode * p = t;
            while (p->sibling != NULL) p = p->sibling;
            p->sibling = s;
            return t;
        }
        return s;
    }
%}

%define parse.error verbose

/* DEFINIÇÃO DA UNIÃO (Tipos de dados que o Bison manipula) */
%union {
    TreeNode * node;
    char * string;
    int val;
    int op;
}


%token<val> NUM
%token<string> ID

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

/* Tipos dos Não-Terminais */
%type <node> empty

/* Definição de precedência e associatividade */
%left MAIS SUB
%left MULT DIV

/* Definição para resolver o problema de ambiguidade de else */
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

/* Tipos dos Não-Terminais (Todos retornam nós de árvore) */
%type <node> declaration_list declaration var_declaration fun_declaration
%type <node> params param_list param compound_stmt local_declarations statement_list
%type <node> statement expression_stmt selection_stmt iteration_stmt return_stmt
%type <node> expression var simple_expression additive_expression term factor call args arg_list
%type <op> relop addop mulop type_specifier


%start program

%%

    program:
        declaration_list     { savedTree = $1; }
    ;

    declaration_list:
        declaration_list declaration    { $$ = addSibling($1, $2); }
        | declaration    { $$ = $1; }
    ;

    declaration:
        var_declaration      { $$ = $1; }
        | fun_declaration    { $$ = $1; }
    ;

    var_declaration:
        type_specifier ID PONTV
        { 
            $$ = newDecNode(VarK);
            $$->type = ($1 == INT) ? Integer : Void;
            $$->attr.name = copyString($2);
            insere_ts($2, linha_atual, localizacao++, escopo, "var", idTipo); 
        }
        | type_specifier ID ACOL NUM FCOL PONTV 
    {
        $$ = newDecNode(VarK);
        $$->type = ($1 == INT) ? Integer : Void;
        $$->attr.name = copyString($2);
        TreeNode * t = newExpNode(ConstK);
        t->attr.val = $4;
        $$->child[0] = t;
        insere_ts($2, linha_atual, localizacao++, escopo, "vet", idTipo);
        localizacao += $4 - 1;
    }
        | error PONTV
    {
        yyerrok;
        $$ = NULL;
    }
    ;

    type_specifier:
        INT { idTipo = "int"; $$ = INT; }
        | VOID { idTipo = "void"; $$ = VOID; }
    ;

    fun_declaration:
        type_specifier ID 
        { 
         /* Insere a função no escopo GLOBAL antes de entrar nela */
         insere_ts($2, linha_atual, 0, "global", "fun", idTipo);
         
         /* Muda o escopo para o nome da função */
         escopo = $2; 
         
         /* Zera localizador de memória para as variáveis locais */
         localizacao = 0; 
         ContadorBloco = 1;
        }
        APAR params FPAR compound_stmt
        {
            $$ = newDecNode(FunK);
            $$->type = ($1 == INT) ? Integer : Void;
            $$->attr.name = copyString($2);
            $$->child[0] = $5; /* Parametros */
            $$->child[1] = $7; /* Corpo da função */
            escopo = "global";
        }
    ;

    params:
        param_list { $$ = $1; }
        | VOID { $$ = NULL; }
    ;

    param_list:
        param_list VIRG param
        { $$ = addSibling($1, $3); }
        | param
        { $$ = $1; }
    ;

    param:
        type_specifier ID
        { 
            $$ = newDecNode(ParamK);
            $$->type = ($1 == INT) ? Integer : Void;
            $$->attr.name = copyString($2);
            insere_ts($2, linha_atual, localizacao++, escopo, "var", idTipo); 
        }
        | type_specifier ID ACOL FCOL
        { 
            $$ = newDecNode(ParamK);
            $$->type = ($1 == INT) ? Integer : Void;
            $$->attr.name = copyString($2);
            insere_ts($2, linha_atual, localizacao++, escopo, "vet", idTipo); 
        }
    ;

    compound_stmt:
    ACHAV
    {
        /* Salva escopo atual */
        strcpy(escopoAnterior, escopo);

        /* Cria escopo novo (bloco anônimo) */
        static int bloco = 1;
        char buffer[50];
        sprintf(buffer, "%s_B%d", escopo, ContadorBloco++);
        escopo = strdup(buffer);
    }
    local_declarations statement_list FCHAV
    {
        $$ = newStmtNode(CompoundK);
        $$->child[0] = $3;
        $$->child[1] = $4;

        /* Restaura escopo */
        escopo = strdup(escopoAnterior);
    }
 ;

    local_declarations:
        local_declarations var_declaration     { $$ = addSibling($1, $2); }
        | empty     { $$ = NULL; }
    ;

    statement_list:
        statement_list statement     { $$ = addSibling($1, $2); }
        | empty     { $$ = NULL; }
    ;

    statement:
        expression_stmt { $$ = $1; }
        | compound_stmt { $$ = $1; }
        | selection_stmt { $$ = $1; }
        | iteration_stmt { $$ = $1; }
        | return_stmt { $$ = $1; }
    ;

    expression_stmt:
        expression PONTV   { $$ = $1; }
        | PONTV  { $$ = NULL; }
        | error PONTV
        {
            yyerrok;
            $$ = NULL;
        }
    ;

    selection_stmt:
        IF APAR expression FPAR statement %prec LOWER_THAN_ELSE
        {
        $$ = newStmtNode(IfK);
        $$->child[0] = $3; /* Condição */
        $$->child[1] = $5; /* Then */
        }
        | IF APAR expression FPAR statement ELSE statement
        {
        $$ = newStmtNode(IfK);
        $$->child[0] = $3; /* Condição */
        $$->child[1] = $5; /* Then */
        $$->child[2] = $7; /* Else */
        }
    ;

    iteration_stmt:
        WHILE APAR expression FPAR statement
        {
        $$ = newStmtNode(WhileK);
        $$->child[0] = $3; /* Condição */
        $$->child[1] = $5; /* Corpo */
        }
    ;

    return_stmt:
        RETURN PONTV        { $$ = newStmtNode(ReturnK); }
        | RETURN expression PONTV
        {
        $$ = newStmtNode(ReturnK);
        $$->child[0] = $2; /* Valor retornado */
        }
    ;

    expression:
        var ATRIB expression
        {
        $$ = newExpNode(OpK);
        $$->attr.op = ATRIB;
        $$->child[0] = $1; /* Variável */
        $$->child[1] = $3; /* Valor */
        }
        | simple_expression     { $$ = $1; }
    ;

    var:
        ID
        { 
            $$ = newExpNode(IdK);
            $$->attr.name = copyString($1);
            verifica_declarada($1, escopo, linha_atual);
        }
        | ID ACOL expression FCOL
        {
            $$ = newExpNode(IdK);
            $$->attr.name = copyString($1);
            $$->child[0] = $3; /* Indice do vetor */
            verifica_declarada($1, escopo, linha_atual);
        }
    ;
    
    simple_expression:
        additive_expression relop additive_expression
        {
        $$ = newExpNode(OpK);
        $$->attr.op = $2;
        $$->child[0] = $1;
        $$->child[1] = $3;
        }
        | additive_expression    { $$ = $1; }
    ;

    relop:
        MENORIG { $$ = MENORIG; }
        | MENOR { $$ = MENOR; }
        | MAIOR { $$ = MAIOR; }
        | MAIORIG { $$ = MAIORIG; }
        | IGUALD { $$ = IGUALD; }
        | DIFF { $$ = DIFF; }
    ;

    additive_expression:
        additive_expression addop term 
        {
        $$ = newExpNode(OpK);
        $$->attr.op = $2;
        $$->child[0] = $1;
        $$->child[1] = $3;
        }
        | term  { $$ = $1; }
    ;
    
    addop:
        MAIS { $$ = MAIS; }
        | SUB { $$ = SUB; }
    ;

    term:
        term mulop factor
        {
            $$ = newExpNode(OpK);
            $$->attr.op = $2;
            $$->child[0] = $1;
            $$->child[1] = $3;
        }
        | factor { $$ = $1; }
    ;

    mulop:
        MULT { $$ = MULT; }
        | DIV { $$ = DIV; }
    ;

    factor:
        APAR expression FPAR { $$ = $2; }
        | var { $$ = $1; }
        | call { $$ = $1; }
        | NUM
        {
            $$ = newExpNode(ConstK);
            $$->attr.val = $1;
        }
    ;

    call: 
        ID APAR args FPAR
        {
            $$ = newExpNode(CallK);
            $$->attr.name = copyString($1);
            $$->child[0] = $3; /* Argumentos */
            verifica_funcao_declarada($1, escopo, linha_atual);
        }
    ;
    
    args:
        arg_list { $$ = $1; }
        | empty { $$ = NULL; }
    ;

    arg_list:
        arg_list VIRG expression
        { $$ = addSibling($1, $3); }
        | expression
        { $$ = $1; }
    ;

    empty:
        /* vazio */
        { $$ = NULL; }
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
        fprintf(stderr, "  esperado '%s' - LINHA: %d", esperado + 10, linha_atual);
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

    if (result == 0 && savedTree != NULL) {
        printf("\n=== ARVORE SINTATICA ===\n");
        printTree(savedTree);
    }

    codeGen(savedTree, NULL);

    printf("\n=== TABELA DE SIMBOLOS ===\n");
    print_ts(stdout); 

    liberaTabela();
    
    return 0;
}