#ifndef _CODE_GEN_H_
#define _CODE_GEN_H_
#define MAX_QUAD 1000

typedef struct {
    char * op;
    char * arg1;
    char * arg2;
    char * result;
} Quadrupla;


extern Quadrupla codigoIntermediario[MAX_QUAD];
extern int totalQuadruplas;

#include "globals.h"

/* Função principal de geração de código
 * Recebe a árvore sintática e gera código intermediário de 3 endereços
 */
void codeGen(TreeNode * syntaxTree, char * codefile);

#endif