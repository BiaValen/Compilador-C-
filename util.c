#include "util.h"
#include "globals.h"
#include "sintax.tab.h"
#include <string.h>

/* Variável global para controlar a linha atual */
int linha_atual = 0;

/* Função para copiar strings */
char * copyString(char * s) {
    int n;
    char * t;
    if (s == NULL) return NULL;
    n = strlen(s) + 1;
    t = (char *) malloc(n);
    if (t == NULL)
        fprintf(stderr, "Memória insuficiente na linha %d\n", linha_atual);
    else strcpy(t, s);
    return t;
}

/* Criar nó de Statement (comando) */
noArvore * newStmtNode(StmtKind kind) {
    noArvore * t = (noArvore *) malloc(sizeof(noArvore));
    int i;
    if (t == NULL)
        fprintf(stderr, "Memória insuficiente na linha %d\n", linha_atual);
    else {
        for (i = 0; i < MAXCHILDREN; i++) t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = StmtK;
        t->kind.stmt = kind;
        t->lineno = linha_atual;
    }
    return t;
}

/* Criar nó de Expression (expressão) */
noArvore * newExpNode(ExpKind kind) {
    noArvore * t = (noArvore *) malloc(sizeof(noArvore));
    int i;
    if (t == NULL)
        fprintf(stderr, "Memória insuficiente na linha %d\n", linha_atual);
    else {
        for (i = 0; i < MAXCHILDREN; i++) t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = ExpK;
        t->kind.exp = kind;
        t->lineno = linha_atual;
        t->type = Void;
    }
    return t;
}

/* Criar nó de Declaration (declaração) */
noArvore * newDecNode(DeclKind kind) {
    noArvore * t = (noArvore *) malloc(sizeof(noArvore));
    int i;
    if (t == NULL)
        fprintf(stderr, "Memória insuficiente na linha %d\n", linha_atual);
    else {
        for (i = 0; i < MAXCHILDREN; i++) t->child[i] = NULL;
        t->sibling = NULL;
        t->nodekind = DeclK;
        t->kind.decl = kind;
        t->lineno = linha_atual;
    }
    return t;
}

/* Função auxiliar para obter o nome do nó */
static void getNodeName(noArvore * tree, char * buffer) {
    if (tree->nodekind == StmtK) {
        switch (tree->kind.stmt) {
            case IfK: sprintf(buffer, "If"); break;
            case WhileK: sprintf(buffer, "While"); break;
            case ReturnK: sprintf(buffer, "Return"); break;
            case CompoundK: sprintf(buffer, "Compound"); break;
            default: sprintf(buffer, "Stmt"); break;
        }
    }
    else if (tree->nodekind == ExpK) {
        switch (tree->kind.exp) {
            case OpK:
                switch (tree->attr.op) {
                    case MAIS: sprintf(buffer, "+"); break;
                    case SUB: sprintf(buffer, "-"); break;
                    case MULT: sprintf(buffer, "*"); break;
                    case DIV: sprintf(buffer, "/"); break;
                    case MENOR: sprintf(buffer, "<"); break;
                    case MENORIG: sprintf(buffer, "<="); break;
                    case MAIOR: sprintf(buffer, ">"); break;
                    case MAIORIG: sprintf(buffer, ">="); break;
                    case IGUALD: sprintf(buffer, "=="); break;
                    case DIFF: sprintf(buffer, "!="); break;
                    case ATRIB: sprintf(buffer, "="); break;
                    default: sprintf(buffer, "Op"); break;
                }
                break;
            case ConstK: sprintf(buffer, "%d", tree->attr.val); break;
            case IdK: sprintf(buffer, "%s", tree->attr.name); break;
            case CallK: sprintf(buffer, "call(%s)", tree->attr.name); break;
            default: sprintf(buffer, "Exp"); break;
        }
    }
    else if (tree->nodekind == DeclK) {
        switch (tree->kind.decl) {
            case VarK: sprintf(buffer, "var:%s", tree->attr.name); break;
            case FunK: sprintf(buffer, "func:%s", tree->attr.name); break;
            case ParamK: sprintf(buffer, "param:%s", tree->attr.name); break;
            default: sprintf(buffer, "Decl"); break;
        }
    }
    else sprintf(buffer, "Node");
}

void printGraphvizNode(noArvore * tree) {
    char nodeName[100];
    int i;
    
    if (tree == NULL) return;

    /* Pega o nome do nó (If, While, +, etc) */
    getNodeName(tree, nodeName);
    
    /* Cria o nó usando o endereço de memória como ID único */
    /* shape=box deixa quadrado igual sua imagem de referência */
    printf("  node%p [label=\"%s\", shape=box];\n", (void*)tree, nodeName);

    /* Conecta com os filhos */
    for (i = 0; i < MAXCHILDREN; i++) {
        if (tree->child[i] != NULL) {
            printf("  node%p -> node%p;\n", (void*)tree, (void*)tree->child[i]);
            printGraphvizNode(tree->child[i]);
        }
    }

    /* Conecta com o irmão (linha tracejada para diferenciar) */
    if (tree->sibling != NULL) {
        /* rank=same força eles a ficarem na mesma altura */
        printf("  { rank=same; node%p; node%p; }\n", (void*)tree, (void*)tree->sibling);
        printf("  node%p -> node%p [style=dashed];\n", (void*)tree, (void*)tree->sibling);
        printGraphvizNode(tree->sibling);
    }
}

/* Função principal */
void printTree(noArvore * tree) {
    printf("digraph AST {\n");
    printf("  node [fontname=\"Arial\"];\n");
    
    if (tree != NULL) {
        printGraphvizNode(tree);
    }
    
    printf("}\n");
}