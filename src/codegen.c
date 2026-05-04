#include "globals.h"
#include "codegen.h"
#include "sintax.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

/* ============================================================
   ARMAZENAMENTO DAS QUÁDRUPLAS
   ============================================================ */

Quadrupla codigoIntermediario[MAX_QUAD];
int totalQuadruplas = 0;

/* Emite uma quádrupla: armazena no array E imprime na tela */
static void emitQuad(char * op, char * arg1, char * arg2, char * result) {
    if (totalQuadruplas >= MAX_QUAD) {
        fprintf(stderr, "ERRO: limite de quádruplas atingido!\n");
        return;
    }

    /* Armazena no array (copia as strings para não depender de ponteiros voláteis) */
    codigoIntermediario[totalQuadruplas].op     = op     ? strdup(op)     : strdup("-");
    codigoIntermediario[totalQuadruplas].arg1   = arg1   ? strdup(arg1)   : strdup("-");
    codigoIntermediario[totalQuadruplas].arg2   = arg2   ? strdup(arg2)   : strdup("-");
    codigoIntermediario[totalQuadruplas].result = result ? strdup(result) : strdup("-");
    totalQuadruplas++;

    /* Continua imprimindo na tela para debug */
    printf("(%s, %s, %s, %s)\n",
        op     ? op     : "-",
        arg1   ? arg1   : "-",
        arg2   ? arg2   : "-",
        result ? result : "-");
}

/* ============================================================
   CONTADORES DE TEMPORÁRIOS E LABELS
   ============================================================ */

static int tmpOffset   = 0;
static int labelOffset = 0;

static char * newTemp() {
    static char buffer[10];
    sprintf(buffer, "t%d", ++tmpOffset);
    char * s = (char *) malloc(strlen(buffer) + 1);
    strcpy(s, buffer);
    return s;
}

static char * newLabel() {
    static char buffer[10];
    sprintf(buffer, "L%d", ++labelOffset);
    char * s = (char *) malloc(strlen(buffer) + 1);
    strcpy(s, buffer);
    return s;
}

/* ============================================================
   GERAÇÃO RECURSIVA DE QUÁDRUPLAS
   ============================================================ */

static char * cGen(TreeNode * tree) {
    char * p1, * p2;
    char * label1, * label2;
    char * currentTemp;
    char * result = NULL;

    if (tree == NULL) return NULL;

    switch (tree->nodekind) {

    case StmtK:
        switch (tree->kind.stmt) {

            case IfK:
                p1     = cGen(tree->child[0]);
                label1 = newLabel(); /* label do ELSE (ou fim) */
                label2 = newLabel(); /* label do FIM */

                emitQuad("IFF", p1, label1, "-");

                cGen(tree->child[1]); /* bloco THEN */

                if (tree->child[2] != NULL) {
                    emitQuad("GOTO", label2, "-", "-");
                    emitQuad("LAB",  label1, "-", "-");
                    cGen(tree->child[2]); /* bloco ELSE */
                    emitQuad("LAB",  label2, "-", "-");
                } else {
                    emitQuad("LAB", label1, "-", "-");
                }
                break;

            case WhileK:
                label1 = newLabel(); /* início do loop */
                label2 = newLabel(); /* saída do loop  */

                emitQuad("LAB", label1, "-", "-");
                p1 = cGen(tree->child[0]); /* condição */
                emitQuad("IFF", p1, label2, "-");

                cGen(tree->child[1]); /* corpo */
                emitQuad("GOTO", label1, "-", "-");
                emitQuad("LAB",  label2, "-", "-");
                break;

            case ReturnK:
                p1 = cGen(tree->child[0]);
                if (p1 != NULL) {
                    emitQuad("RET", p1, "-", "-");
                } else {
                    emitQuad("RET", "-", "-", "-");
                }
                break;

            case CompoundK:
                cGen(tree->child[0]); /* declarações locais */
                cGen(tree->child[1]); /* statements        */
                break;
        }
        break;

    case ExpK:
        switch (tree->kind.exp) {

            case IdK:
                if (tree->child[0] != NULL) {
                    /* Acesso a vetor: t = a[índice] */
                    char * indexTemp = cGen(tree->child[0]);
                    currentTemp = newTemp();
                    emitQuad("LOAD", tree->attr.name, indexTemp, currentTemp);
                    result = currentTemp;
                } else {
                    /* Variável simples */
                    result = tree->attr.name;
                }
                break;

            case ConstK: {
                currentTemp = newTemp();
                char valStr[20];
                sprintf(valStr, "%d", tree->attr.val);
                emitQuad("ASSIGN", valStr, "-", currentTemp);
                result = currentTemp;
                break;
            }

            case OpK:
                if (tree->attr.op == ATRIB) {
                    if (tree->child[0]->nodekind == ExpK &&
                        tree->child[0]->kind.exp  == IdK &&
                        tree->child[0]->child[0]  != NULL) {
                        /* Atribuição em vetor: a[índice] = valor */
                        char * indexTemp = cGen(tree->child[0]->child[0]);
                        p2 = cGen(tree->child[1]);
                        emitQuad("STORE", p2, indexTemp, tree->child[0]->attr.name);
                        result = tree->child[0]->attr.name;
                    } else {
                        /* Atribuição de variável simples */
                        p1 = cGen(tree->child[0]);
                        p2 = cGen(tree->child[1]);
                        emitQuad("ASSIGN", p2, "-", p1);
                        result = p1;
                    }
                } else {
                    /* Operação aritmética ou relacional */
                    p1 = cGen(tree->child[0]);
                    p2 = cGen(tree->child[1]);
                    currentTemp = newTemp();

                    char * op = "";
                    switch (tree->attr.op) {
                        case MAIS:    op = "ADD";  break;
                        case SUB:     op = "SUB";  break;
                        case MULT:    op = "MULT"; break;
                        case DIV:     op = "DIV";  break;
                        case MENOR:   op = "LT";   break;
                        case MENORIG: op = "LE";   break;
                        case MAIOR:   op = "GT";   break;
                        case MAIORIG: op = "GE";   break;
                        case IGUALD:  op = "EQ";   break;
                        case DIFF:    op = "NEQ";  break;
                        default:      op = "?";    break;
                    }

                    emitQuad(op, p1, p2, currentTemp);
                    result = currentTemp;
                }
                break;

            case CallK: {
                TreeNode * arg = tree->child[0];
                int nargs = 0;

                /* Empilha argumentos (sibling anulado para evitar dupla geração) */
                while (arg != NULL) {
                    TreeNode * next = arg->sibling;
                    arg->sibling = NULL;
                    char * t = cGen(arg);
                    arg->sibling = next;
                    emitQuad("PARAM", t, "-", "-");
                    nargs++;
                    arg = next;
                }

                /* Chamadas de I/O */
                if (strcmp(tree->attr.name, "input") == 0) {
                    currentTemp = newTemp();
                    emitQuad("CALL", "input", "0", currentTemp);
                    result = currentTemp;
                } else if (strcmp(tree->attr.name, "output") == 0) {
                    emitQuad("CALL", "output", "1", "-");
                    result = NULL;
                } else {
                    currentTemp = newTemp();
                    char nargsStr[10];
                    sprintf(nargsStr, "%d", nargs);
                    emitQuad("CALL", tree->attr.name, nargsStr, currentTemp);
                    result = currentTemp;
                }
                break;
            }
        }
        break;

    case DeclK:
        if (tree->kind.decl == FunK) {
            char * tipo_retorno = (tree->type == Integer) ? "int" : "void";
            emitQuad("FUN", tipo_retorno, tree->attr.name, "-");
            cGen(tree->child[1]); /* corpo da função */
            emitQuad("END", tree->attr.name, "-", "-");
        }
        break;

    } /* fim do switch nodekind */

    /* Processa o próximo nó irmão */
    cGen(tree->sibling);

    return result;
}

/* ============================================================
   PONTO DE ENTRADA
   ============================================================ */

void codeGen(TreeNode * syntaxTree, char * codefile) {
    printf("\n=== CODIGO QUADRUPLAS ===\n\n");
    cGen(syntaxTree);
}