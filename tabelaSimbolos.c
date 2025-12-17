#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tabelasimbolos.h"

/* O bucket é um nó da lista encadeada dentro de cada posição do hash */
typedef struct ListaLinhaRec { 
    int linhano;
    struct ListaLinhaRec * next;
} * ListaLinha;

typedef struct TabelaRec { 
    char * name;
    ListaLinha linhas;
    int memloc; /* Localização na memória para geração de código */
    char* scope; /* Escopo da variável */
    char* tipoID; 
    char* tipoData; 
    struct TabelaRec * next;
} * Tabela;

/* A tabela hash em si */
static Tabela hashTable[SIZE];

/* Inicializa a tabela hash */
void criaTabela() {
    int i;
    for (i = 0; i < SIZE; i++) {
        hashTable[i] = NULL;
    }
    
    /* Adiciona funcoes built-in (input e output) */
    insere_ts("input", 0, 0, "global", "fun", "int");
    insere_ts("output", 0, 0, "global", "fun", "void");
}

/* Libera toda a memória da tabela hash */
void liberaTabela() {
    int i;
    for (i = 0; i < SIZE; i++) {
        Tabela l = hashTable[i];
        while (l != NULL) {
            Tabela temp = l;
            l = l->next;

            // Libera lista de linhas
            ListaLinha t = temp->linhas;
            while (t != NULL) {
                ListaLinha t2 = t;
                t = t->next;
                free(t2);
            }

            // Libera strings duplicadas
            free(temp->name);
            free(temp->scope);
            free(temp->tipoID);
            free(temp->tipoData);

            // Libera o nó da tabela
            free(temp);
        }

        hashTable[i] = NULL;
    }
}

/* Função Hash (Baseada no algoritmo do livro Louden) */
static int hash ( char * key ) { 
    int temp = 0;
    int i = 0;
    while (key[i] != '\0') { 
        temp = ((temp << 4) + key[i]) % SIZE;
        ++i;
    }
    return temp;
}

/* Inserção na Tabela */
int insere_ts( char * name, int linhano, int loc, char* scope, char* tipoID, char* tipoData) { 
    int h = hash(name);
    Tabela l =  hashTable[h];
    
    /* Procura se já existe SÓ naquele escopo específico */
    /* Variáveis com mesmo nome em escopos diferentes são permitidas */
    while ((l != NULL) && ((strcmp(name,l->name) != 0) || (strcmp(scope,l->scope) != 0)))
        l = l->next;
        
    if (l == NULL) { /* Não achou, insere novo nó */
        l = (Tabela) malloc(sizeof(struct TabelaRec));
        l->name = strdup(name);
        l->linhas = (ListaLinha) malloc(sizeof(struct ListaLinhaRec));
        l->linhas->linhano = linhano;
        l->memloc = loc;
        l->linhas->next = NULL;
        l->scope = strdup(scope);
        l->tipoID = strdup(tipoID);
        l->tipoData = strdup(tipoData);
        l->next = hashTable[h];
        hashTable[h] = l;
        return 1; /* Inserção bem sucedida */
    }
    else { 
        /* Variável JÁ declarada no mesmo escopo - ERRO SEMÂNTICO */
        fprintf(stderr, "ERRO SEMANTICO: Variavel '%s' ja declarada (DUPLICAO)- LINHA %d:\n", 
                name, linhano, l->linhas->linhano);
        return 0; /* Falha na inserção */
    }
}

/* Busca na Tabela */
/* Retorna ponteiro para o símbolo ou NULL se não encontrar */
Tabela verifica_ts ( char * name, char* scope ) { 
    int h = hash(name);
    Tabela l =  hashTable[h];
    
    /* 1. Tenta achar no escopo local */
    while ((l != NULL) && ((strcmp(name,l->name) != 0) || (strcmp(scope,l->scope) != 0)))
        l = l->next;
    
    if (l == NULL) {
        /* 2. Se não achou no local, tenta no escopo GLOBAL */
        l = hashTable[h];
        while ((l != NULL) && ((strcmp(name,l->name) != 0) || (strcmp("global",l->scope) != 0)))
            l = l->next;
    }

    return l; /* Retorna o símbolo ou NULL */
}

void sobe_escopo(char *scope) {
    char *p = strrchr(scope, '_');
    if (p != NULL)
        *p = '\0';
    else
        strcpy(scope, "global");
}

/* Verifica se variável foi declarada - retorna 1 se encontrou, 0 se não */
int verifica_declarada(char* name, char* scope, int linha) {
    char escopoTemp[100];
    strcpy(escopoTemp, scope);

    /* Sobe na cadeia de escopos */
    while (1) {
        Tabela l = verifica_ts(name, escopoTemp);
        if (l != NULL)
            return 1; /* Encontrada */

        /* Se já chegou no global e não achou */
        if (strcmp(escopoTemp, "global") == 0)
            break;

        sobe_escopo(escopoTemp);
    }

    fprintf(stderr,
        "ERRO SEMANTICO: Variavel '%s' nao declarada - LINHA %d:\n",
        name, linha
    );

    return 0;
}

/* Imprime a Tabela Formatada */
void print_ts(FILE * listing) { 
    int i;
    int contador = 0;
    fprintf(listing,"#    Nome           Escopo         TipoID  TipoDado  Loc   Linhas\n");
    fprintf(listing,"---  -------------  -------------  ------  --------  ----  ------\n");
    
    for (i=0;i<SIZE;++i) { 
        if (hashTable[i] != NULL) { 
            Tabela l = hashTable[i];
            while (l != NULL) { 
                ListaLinha t = l->linhas;
                fprintf(listing,"%-3d  ", contador++);
                fprintf(listing,"%-14s ",l->name);
                fprintf(listing,"%-14s ",l->scope);
                fprintf(listing,"%-7s ",l->tipoID);
                fprintf(listing,"%-9s ",l->tipoData);
                fprintf(listing,"%-5d  ",l->memloc);
                while (t != NULL) { 
                    fprintf(listing,"%4d ",t->linhano);
                    t = t->next;
                }
                fprintf(listing,"\n");
                l = l->next;
            }
        }
    }
}

/* ========== VERIFICAÇÕES SEMÂNTICAS ========== */

/* Verifica incompatibilidade de tipos em atribuição */
int verifica_tipo_atribuicao(char* varName, char* tipoEsperado, char* tipoRecebido, char* scope, int linha) {
    if (strcmp(tipoEsperado, tipoRecebido) != 0) {
        fprintf(stderr, "ERRO SEMANTICO: Incompatibilidade de tipos na atribuicao - LINHA %d:\n", linha);
        fprintf(stderr, "  Variavel '%s' espera tipo '%s', mas recebeu '%s'\n", varName, tipoEsperado, tipoRecebido);
        return 0;
    }
    return 1;
}

/* Verifica se variável é do tipo void (não permitido) */
int verifica_var_void(char* varName, char* tipo, int linha) {
    if (strcmp(tipo, "void") == 0) {
        fprintf(stderr, "ERRO SEMANTICO: Variavel nao pode ser do tipo 'void' - LINHA %d:\n", linha);
        fprintf(stderr, "  Variavel '%s' declarada como void\n", varName);
        return 0;
    }
    return 1;
}

/* Verifica se função main existe e está correta */
int verifica_main() {
    Tabela main_func = verifica_ts("main", "global");
    
    if (main_func == NULL) {
        fprintf(stderr, "ERRO SEMANTICO: Funcao 'main' nao foi declarada\n");
        fprintf(stderr, "  Todo programa deve ter uma funcao 'void main(void)'\n");
        return 0;
    }
    
    if (strcmp(main_func->tipoID, "funcao") != 0) {
        fprintf(stderr, "ERRO SEMANTICO: 'main' deve ser uma funcao\n");
        return 0;
    }
    
    if (strcmp(main_func->tipoData, "void") != 0) {
        fprintf(stderr, "ERRO SEMANTICO: Funcao 'main' deve retornar 'void' - LINHA %d:\n", main_func->linhas->linhano);
        fprintf(stderr, "  Encontrado: '%s main(...)'\n", main_func->tipoData);
        return 0;
    }
    
    return 1;
}

/* Verifica se funções input() e output() foram usadas corretamente */
int verifica_input_output(char* funcName, int numParams, int linha) {
    if (strcmp(funcName, "input") == 0) {
        if (numParams != 0) {
            fprintf(stderr, "ERRO SEMANTICO: Funcao 'input()' nao aceita parametros - LINHA %d:\n", linha);
            fprintf(stderr, "  Esperado: input()\n");
            return 0;
        }
    }
    
    if (strcmp(funcName, "output") == 0) {
        if (numParams != 1) {
            fprintf(stderr, "ERRO SEMANTICO: Funcao 'output()' requer exatamente 1 parametro - LINHA %d:\n", linha);
            fprintf(stderr, "  Esperado: output(expressao)\n");
            return 0;
        }
    }
    
    return 1;
}

/* Verifica operação com tipos incompatíveis */
int verifica_tipos_operacao(char* tipo1, char* tipo2, char operador, int linha) {
    /* Em C-, só permitimos int com int */
    if (strcmp(tipo1, "int") != 0 || strcmp(tipo2, "int") != 0) {
        fprintf(stderr, "ERRO SEMANTICO: Operacao '%c' com tipos incompativeis - LINHA %d:\n", operador, linha);
        fprintf(stderr, "  Tipo esquerda: '%s', Tipo direita: '%s'\n", tipo1, tipo2);
        fprintf(stderr, "  Apenas operacoes entre 'int' sao permitidas\n");
        return 0;
    }
    return 1;
}

/* Verifica divisão por zero literal */
int verifica_divisao_zero(int divisor, int linha) {
    if (divisor == 0) {
        fprintf(stderr, "ERRO SEMANTICO: Divisao por zero detectada - LINHA %d:\n", linha);
        return 0;
    }
    return 1;
}

/* Verifica se função foi declarada antes de ser chamada */
int verifica_funcao_declarada(char* funcName, char* scope, int linha) {
    Tabela func = verifica_ts(funcName, scope);
    
    if (func == NULL) {
        fprintf(stderr, "ERRO SEMANTICO: Funcao '%s' nao foi declarada - LINHA %d:\n", funcName, linha);
        return 0;
    }
    
    if (strcmp(func->tipoID, "fun") != 0) {
        fprintf(stderr, "ERRO SEMANTICO: '%s' nao e uma funcao - LINHA %d:\n", funcName, linha);
        return 0;
    }
    
    return 1;
}

/* Verifica número de parâmetros em chamada de função */
int verifica_num_parametros(char* funcName, int esperado, int recebido, int linha) {
    if (esperado != recebido) {
        fprintf(stderr, "ERRO SEMANTICO: Numero incorreto de parametros para '%s' - LINHA %d:\n", funcName, linha);
        fprintf(stderr, "  Esperado: %d, Recebido: %d\n", esperado, recebido);
        return 0;
    }
    return 1;
}