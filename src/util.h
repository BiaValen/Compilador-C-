#ifndef _UTIL_H_
#define _UTIL_H_

#include "globals.h"

/* Funções para criar nós da árvore */
noArvore * newStmtNode(StmtKind kind);
noArvore * newExpNode(ExpKind kind);
noArvore * newDecNode(DeclKind kind);

/* Função para imprimir a árvore sintática */
void printTree(noArvore * tree);

/* Função para copiar strings */
char * copyString(char * s);

#endif