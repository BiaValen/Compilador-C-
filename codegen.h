#ifndef _CODE_GEN_H_
#define _CODE_GEN_H_

#include "globals.h"

/* Função principal de geração de código
 * Recebe a árvore sintática e gera código intermediário de 3 endereços
 */
void codeGen(TreeNode * syntaxTree, char * codefile);

#endif