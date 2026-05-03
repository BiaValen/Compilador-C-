#ifndef _GLOBALS_H_
#define _GLOBALS_H_

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>

/* Número máximo de filhos por nó */
#define MAXCHILDREN 3

/* Tipos de nós da árvore sintática */
typedef enum {StmtK, ExpK, DeclK} NodeKind;

/* Subtipos para declarações */
typedef enum {VarK, FunK, ParamK} DeclKind;

/* Subtipos para comandos/statements */
typedef enum {IfK, WhileK, ReturnK, CompoundK} StmtKind; //compound é o bloco de comandos

/* Subtipos para expressões */
typedef enum {OpK, ConstK, IdK, CallK} ExpKind;

/* Tipos de dados */
typedef enum {Void, Integer} ExpType;

/* Estrutura de um nó da árvore sintática */
typedef struct noArvore {
    struct noArvore * child[MAXCHILDREN];
    struct noArvore * sibling;
    int lineno;
    NodeKind nodekind;
    
    union {
        DeclKind decl;
        StmtKind stmt;
        ExpKind exp;
    } kind;
    
    union {
        int op;        /*  nós OpK (operadores) */
        int val;       /*  nós ConstK (constantes) */
        char * name;   /* nós IdK, FunK, VarK, ParamK */
    } attr;
    
    ExpType type;  /* Para checagem de tipos */
} noArvore;

/* Alias para compatibilidade */
typedef noArvore TreeNode;

/* Variável global externa para a linha atual */
extern int linha_atual;

#endif