#include "globals.h"
#include "codegen.h"
#include "sintax.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

/* Contador para variáveis temporárias (t1, t2, t3...) */
static int tmpOffset = 0;

/* Contador para labels (L1, L2...) usados em IF/WHILE */
static int labelOffset = 0;

/* Gera um novo nome temporário (t1, t2...) */
static char * newTemp() {
    static char buffer[10];
    sprintf(buffer, "t%d", ++tmpOffset);
    char * s = (char *) malloc(strlen(buffer) + 1);
    strcpy(s, buffer);
    return s;
}

/* Gera um novo label (L1, L2...) */
static char * newLabel() {
    static char buffer[10];
    sprintf(buffer, "L%d", ++labelOffset);
    char * s = (char *) malloc(strlen(buffer) + 1);
    strcpy(s, buffer);
    return s;
}

/* Função recursiva principal para gerar código */
static char * cGen(TreeNode * tree) {
    char * p1, * p2;
    char * label1, * label2;
    char * currentTemp;
    char * result = NULL; /* Variável para armazenar o retorno sem sair da função */

    if (tree == NULL) return NULL;

    switch (tree->nodekind) {
    
    case StmtK:
        switch (tree->kind.stmt) {
            case IfK:
                p1 = cGen(tree->child[0]); /* Condição */
                label1 = newLabel(); /* Label para o ELSE (ou fim) */
                label2 = newLabel(); /* Label para o FIM */
                
                printf("ifFalse %s goto %s\n", p1, label1);
                
                cGen(tree->child[1]); /* Bloco THEN */
                
                if (tree->child[2] != NULL) {
                    printf("goto %s\n", label2);
                    printf("label %s\n", label1);
                    cGen(tree->child[2]); /* Bloco ELSE */
                    printf("label %s\n", label2);
                } else {
                    printf("label %s\n", label1);
                }
                break;

            case WhileK:
                label1 = newLabel(); /* Começo do loop */
                label2 = newLabel(); /* Saída do loop */
                
                printf("label %s\n", label1);
                p1 = cGen(tree->child[0]); /* Condição */
                printf("ifFalse %s goto %s\n", p1, label2);
                
                cGen(tree->child[1]); /* Corpo */
                printf("goto %s\n", label1);
                printf("label %s\n", label2);
                break;

            case ReturnK:
                p1 = cGen(tree->child[0]);
                printf("return %s\n", p1 ? p1 : "");
                break;
                
            case CompoundK:
                cGen(tree->child[0]); // Declarações locais
                cGen(tree->child[1]); // Statements
                break;
        }
        break; /* Sai do switch e vai para o sibling */

    case ExpK:
        switch (tree->kind.exp) {
            case OpK:
                if (tree->attr.op == ATRIB) {
                    p1 = cGen(tree->child[0]); /* Variável destino */
                    p2 = cGen(tree->child[1]); /* Valor */
                    printf("%s = %s\n", p1, p2);
                    result = p1; /* Armazena resultado, mas NÃO dá return ainda */
                } 
                else {
                    /* Operação Aritmética ou Relacional */
                    p1 = cGen(tree->child[0]);
                    p2 = cGen(tree->child[1]);
                    currentTemp = newTemp();
                    
                    char * op = "";
                    switch(tree->attr.op) {
                        case MAIS: op = "+"; break;
                        case SUB: op = "-"; break;
                        case MULT: op = "*"; break;
                        case DIV: op = "/"; break;
                        case MENOR: op = "<"; break;
                        case MENORIG: op = "<="; break;
                        case MAIOR: op = ">"; break;
                        case MAIORIG: op = ">="; break;
                        case IGUALD: op = "=="; break;
                        case DIFF: op = "!="; break;
                        default: op = "?"; break;
                    }
                    
                    printf("%s = %s %s %s\n", currentTemp, p1, op, p2);
                    result = currentTemp;
                }
                break; /* Break fundamental para processar o sibling depois */

            case ConstK:
                currentTemp = newTemp();
                printf("%s = %d\n", currentTemp, tree->attr.val);
                result = currentTemp;
                break;

            case IdK:
                result = tree->attr.name;
                break;

            case CallK:
                {
                    TreeNode * arg = tree->child[0];
                    int nargs = 0; /* Contador de argumentos */
                    
                    /* Gera código para empilhar argumentos */
                    while (arg != NULL) {
                        char * t = cGen(arg);
                        printf("param %s\n", t);
                        nargs++;
                        arg = arg->sibling;
                    }
                    
                    /* Verifica chamadas especiais */
                    if (strcmp(tree->attr.name, "input") == 0) {
                        currentTemp = newTemp();
                        printf("%s = call input, 0\n", currentTemp);
                        result = currentTemp;
                    } 
                    else if (strcmp(tree->attr.name, "output") == 0) {
                        printf("call output, 1\n");
                        result = NULL;
                    } 
                    else {
                        currentTemp = newTemp();
                        /* Agora imprime o número de argumentos na chamada */
                        printf("%s = call %s, %d\n", currentTemp, tree->attr.name, nargs);
                        result = currentTemp;
                    }
                }
                break;
        }
        break;
        
    case DeclK:
        if (tree->kind.decl == FunK) {
            printf("_entry %s\n", tree->attr.name); /* Alterado para _entry */
            cGen(tree->child[1]); /* Corpo da função */
            /* Retorno padrão caso o usuário esqueça */
            /* printf("return\n"); (Opcional) */ 
        }
        break;
    }
    
    /* O SEGREDO ESTÁ AQUI: Processa o próximo comando (irmão) */
    /* Se tivermos dado 'return' lá em cima, essa linha nunca seria executada */
    cGen(tree->sibling);
    
    return result;
}

void codeGen(TreeNode * syntaxTree, char * codefile) {
    printf("\n=== CODIGO INTERMEDIARIO (3 ENDERECOS) ===\n\n");
    cGen(syntaxTree);
}