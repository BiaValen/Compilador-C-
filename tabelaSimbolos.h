#ifndef _TABELASIMBOLO_H_
#define _TABELASIMBOLO_H_

#include <stdio.h>

/* Forward declaration */
struct TabelaRec;

/* Tamanho da tabela hash */
#define SIZE 211

/* Inicializa a tabela de símbolos */
void criaTabela();

/* Libera toda memória da tabela */
void liberaTabela();

/* Inserção na Tabela - retorna 1 se sucesso, 0 se erro (redeclaração) */
int insere_ts(char * name, int lineno, int loc, char* scope, char* typeID, char* typeData);

/* Retorna ponteiro para o símbolo ou NULL se não encontrada */
struct TabelaRec* verifica_ts(char * name, char* scope);

/* Verifica se variável foi declarada - retorna 1 se OK, 0 se erro */
int verifica_declarada(char* name, char* scope, int linha);

/* Função para imprimir a tabela formatada */
void print_ts(FILE * listing);

/* ========== VERIFICAÇÕES SEMÂNTICAS ========== */

/* Verifica incompatibilidade de tipos em atribuição */
int verifica_tipo_atribuicao(char* varName, char* tipoEsperado, char* tipoRecebido, char* scope, int linha);

/* Verifica se variável é do tipo void (não permitido) */
int verifica_var_void(char* varName, char* tipo, int linha);

/* Verifica se função main existe e está correta */
int verifica_main();

/* Verifica se funções input() e output() foram usadas corretamente */
int verifica_input_output(char* funcName, int numParams, int linha);

/* Verifica operação com tipos incompatíveis */
int verifica_tipos_operacao(char* tipo1, char* tipo2, char operador, int linha);

/* Verifica divisão por zero literal */
int verifica_divisao_zero(int divisor, int linha);

/* Verifica se função foi declarada antes de ser chamada */
int verifica_funcao_declarada(char* funcName, char* scope, int linha);

/* Verifica número de parâmetros em chamada de função */
int verifica_num_parametros(char* funcName, int esperado, int recebido, int linha);

#endif