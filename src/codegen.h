#ifndef _CODE_GEN_H_
#define _CODE_GEN_H_
#define MAX_QUAD 1000

typedef enum {
    OP_ADD, OP_SUB, OP_MULT, OP_DIV,
    OP_EQ, OP_NEQ, OP_LT, OP_LE, OP_GT, OP_GE,
    OP_ASSIGN, OP_LOAD, OP_STORE, OP_ALLOC,
    OP_LAB, OP_GOTO, OP_IFF,
    OP_FUN, OP_ARG, OP_PARAM, OP_CALL, OP_RET, OP_END, OP_HALT
} Opcode;

typedef enum {
    OPD_EMPTY,  //  "-" 
    OPD_CONST,  // Constante 
    OPD_ID,     // Nome de variável original 
    OPD_TEMP,   // Variável temporária gerada 
    OPD_LABEL   // Rótulo de pulo 
} OpdKind;

typedef struct {
    OpdKind kind;
    union {
        int val;       // Usado se kind for OPD_CONST
        char *name;    // Usado se kind for ID, TEMP ou LABEL
    } contents;
} Operand;

//estrutura de lista encadeada
typedef struct QuadNode {
    Opcode op;              
    Operand arg1;           
    Operand arg2;           
    Operand result;         
    struct QuadNode *next;  // Ponteiro para a próxima instrução na lista
} Quadruple;



// Ponteiros globais para controlar o início e o fim do programa na memória
extern Quadruple * headQuad; 
extern Quadruple * tailQuad; 
extern int totalQuadruplas;

#include "globals.h"

void codeGen(TreeNode * syntaxTree, char * codefile);

#endif