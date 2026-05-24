#include "asmgen.h"
#include "codegen.h"
#include "tabelasimbolos.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>

/* ============================================================
   MODELO DE STACK — convenção adotada:

   Quando o CALLER empilha args e chama gcd(v, u-u/v*v):

       PARAM v        → addi sp,-4 / sw v, 0(sp)
       PARAM t12      → addi sp,-4 / sw t12, 0(sp)
       CALL gcd       → addi sp,-4 / sw ra, 0(sp) / jal ra, gcd

   No início de gcd (ANTES do prólogo):
       0(sp)  = ra do caller
       4(sp)  = último PARAM empilhado  = t12 (2º argumento)
       8(sp)  = primeiro PARAM empilhado = v  (1º argumento)

   O prólogo de gcd NÃO salva ra de novo — já está salvo.
   Variáveis locais crescem para BAIXO a partir de -4(sp):
       -4(sp) = _t1
       -8(sp) = _t2
       ...
   ============================================================ */

/* ============================================================
   TABELA DE SÍMBOLOS LOCAL DO ASMGEN
   ============================================================ */

#define MAX_SYMS 500

typedef struct {
    char name[64];
    int  offset;    /* positivo = parâmetro, negativo = local */
    char scope[64];
} AsmSymbol;

static AsmSymbol asmSym[MAX_SYMS];
static int       asmSymCount = 0;
static int       localSize   = 0;  /* bytes alocados para locais */
static char      curScope[64] = "";
static FILE    * outFile = NULL;

/* Busca símbolo no escopo atual */
static int findSym(const char * name) {
    for (int i = 0; i < asmSymCount; i++) {
        if (strcmp(asmSym[i].name, name) == 0 &&
            strcmp(asmSym[i].scope, curScope) == 0) {
            return i;
        }
    }
    return -1;
}

/* Adiciona símbolo LOCAL (offset negativo) */
static int addLocal(const char * name) {
    int idx = findSym(name);
    if (idx != -1) return idx;
    localSize += 4;
    strcpy(asmSym[asmSymCount].name, name);
    asmSym[asmSymCount].offset = -localSize;
    strcpy(asmSym[asmSymCount].scope, curScope);
    return asmSymCount++;
}

/* Registra parâmetro com offset POSITIVO (já está na stack) */
static void addParam(const char * name, int offset) {
    if (findSym(name) != -1) return;
    strcpy(asmSym[asmSymCount].name, name);
    asmSym[asmSymCount].offset = offset;
    strcpy(asmSym[asmSymCount].scope, curScope);
    asmSymCount++;
}

/* Retorna o offset de um símbolo (cria como local se não existir) */
static int getOffset(const char * name) {
    int idx = findSym(name);
    if (idx == -1) idx = addLocal(name);
    return asmSym[idx].offset;
}

/* ============================================================
   EMISSÃO
   ============================================================ */

static void emit(const char * fmt, ...) {
    va_list args;
    va_start(args, fmt);
    vfprintf(outFile, fmt, args);
    fprintf(outFile, "\n");
    va_end(args);
}

/* ============================================================
   ACESSO A OPERANDS
   ============================================================ */

static int opdEmpty(Operand * o)  { return o->kind == OPD_EMPTY; }
static int opdIsConst(Operand * o){ return o->kind == OPD_CONST; }
static char * opdName(Operand * o){ return o->contents.name; }
static int opdVal(Operand * o)    { return o->contents.val; }

/* Carrega Operand em registrador */
static void loadOpd(Operand * o, const char * reg) {
    if (opdEmpty(o)) return;
    if (opdIsConst(o)) {
        emit("    addi %s, x0, %d", reg, opdVal(o));
    } else {
        int off = getOffset(opdName(o));
        emit("    lw   %s, %d(x8)", reg, off);
    }
}

/* Salva registrador para Operand na stack */
static void storeOpd(Operand * o, const char * reg) {
    if (opdEmpty(o)) return;
    int off = getOffset(opdName(o));
    emit("    sw   %s, %d(x8)", reg, off);
}

/* ============================================================
   GERAÇÃO POR TIPO DE QUÁDRUPLA
   ============================================================ */

static void genFun(Quadruple * q) {
    /*
     * (FUN, tipo, nome, -)
     *
     * O CALLER já salvou ra na stack antes de chamar.
     * Layout no início da função:
     *   0(sp) = ra
     *   4(sp) = último parâmetro (param N-1)
     *   8(sp) = penúltimo parâmetro (param N-2)
     *   ...
     *   (N*4)(sp) = primeiro parâmetro (param 0)
     *
     * NÃO salvamos ra de novo aqui.
     * Variáveis locais começam em -4(sp).
     */
    char * nome = opdName(&q->arg2);
    char * tipo = opdName(&q->arg1);

    strcpy(curScope, nome);
    localSize   = 0;
    asmSymCount = 0;  /* limpa tabela local para nova função */

    /* Registra os parâmetros com offsets positivos */
    int nParams = getNumParams(nome);
    /*
     * O primeiro PARAM empilhado fica mais longe do sp.
     * Se temos 2 params (u, v), a ordem de empilhamento é:
     *   PARAM v  → 4(sp)
     *   PARAM u  → 8(sp)  (foi empilhado ANTES)
     *   ra       → 0(sp)
     *
     * memloc 0 = primeiro parâmetro declarado = offset mais alto
     * memloc 1 = segundo parâmetro declarado  = offset menor
     */
    for (int i = 0; i < nParams; i++) {
        char * paramName = getParamName(nome, i);
        if (paramName != NULL) {
            /* offset = (nParams - i) * 4 */
            int off = (nParams - i) * 4;
            addParam(paramName, off);
        }
    }

    emit("");
    emit("# ---- funcao %s (%s) | %d parametros ----", nome, tipo, nParams);
    emit("%s:", nome);
    emit("    add  x8, x2, x0");   // fp = sp
    /* ra já foi salvo pelo caller — não salvamos de novo */
}

static void genEnd(Quadruple * q) {
    emit("# ---- fim de %s ----", opdName(&q->arg1));
    emit("");
}

static void genAssign(Quadruple * q) {
    loadOpd(&q->arg1, "t0");
    storeOpd(&q->result, "t0");
}

static void genArith(Quadruple * q) {
    loadOpd(&q->arg1, "t0");
    loadOpd(&q->arg2, "t1");
    switch (q->op) {
        case OP_ADD:  emit("    add  t2, t0, t1"); break;
        case OP_SUB:  emit("    sub  t2, t0, t1"); break;
        case OP_MULT: emit("    mul  t2, t0, t1"); break;
        case OP_DIV:  emit("    div  t2, t0, t1"); break;
        default: break;
    }
    storeOpd(&q->result, "t2");
}

static void genRelational(Quadruple * q) {
    loadOpd(&q->arg1, "t0");
    loadOpd(&q->arg2, "t1");
    switch (q->op) {
        case OP_LT:
            emit("    slt  t2, t0, t1");
            break;
        case OP_GT:
            /* a > b  =  b < a */
            emit("    slt  t2, t1, t0");
            break;
        case OP_LE:
            /* a <= b  =  NOT(b < a) */
            emit("    slt  t2, t1, t0");
            emit("    xori t2, t2, 1");
            break;
        case OP_GE:
            /* a >= b  =  NOT(a < b) */
            emit("    slt  t2, t0, t1");
            emit("    xori t2, t2, 1");
            break;
        case OP_EQ:
            /* a XOR b == 0  sse  a == b */
            emit("    xor  t2, t0, t1");
            emit("    slti t2, t2, 1");
            break;
        case OP_NEQ:
            emit("    xor  t2, t0, t1");
            emit("    slti t2, t2, 1");
            emit("    xori t2, t2, 1");
            break;
        default: break;
    }
    storeOpd(&q->result, "t2");
}

static void genIff(Quadruple * q) {
    loadOpd(&q->arg1, "t0");
    emit("    beq  t0, x0, %s", opdName(&q->arg2));
}

static void genGoto(Quadruple * q) {
    emit("    jal  x0, %s", opdName(&q->arg1));
}

static void genLabel(Quadruple * q) {
    emit("%s:", opdName(&q->arg1));
}

static void genParam(Quadruple * q) {
    /*
     * Empilha argumento ANTES da chamada.
     * O último PARAM empilhado fica em 4(sp) quando a função começa
     * (porque depois o CALL empilha ra em 0(sp)).
     */
    loadOpd(&q->arg1, "t0");
    emit("    addi x2, x2, -4");
    emit("    sw   t0, 0(x2)");
}

static void genCall(Quadruple * q) {
    char * funcName = opdName(&q->arg1);

    if (strcmp(funcName, "input") == 0) {
        emit("    lw   t0, 2044(x0)");
        if (!opdEmpty(&q->result)) storeOpd(&q->result, "t0");
        return;
    }

    if (strcmp(funcName, "output") == 0) {
        /* Desempilha o argumento que foi empilhado via PARAM */
        emit("    lw   t0, 0(x2)");
        emit("    addi x2, x2, 4");
        emit("    sw   t0, 2044(x0)");
        return;
    }

    /*
     * Função geral:
     * 1. Salva ra na stack (args já foram empilhados via PARAM)
     * 2. Chama a função
     * 3. Restaura ra
     * 4. Desempilha os args
     * 5. Captura retorno de a0
     */
    int nargs = opdVal(&q->arg2);

    emit("    addi x2, x2, -4");
    emit("    sw   x1, 0(x2)");           /* salva ra */
    emit("    jal  x1, %s", funcName);    /* chama */
    emit("    lw   x1, 0(x2)");           /* restaura ra */
    emit("    addi x2, x2, 4");           /* desempilha ra */

    /* Desempilha argumentos */
    if (nargs > 0) {
        emit("    addi x2, x2, %d", nargs * 4);
    }

    if (!opdEmpty(&q->result)) {
        storeOpd(&q->result, "x10");
    }
}

static void genRet(Quadruple * q) {
    /*
     * Coloca valor de retorno em a0 (x10).
     * Restaura ra (que está em 0(sp) — salvo pelo caller via genCall).
     * Retorna.
     */
    if (!opdEmpty(&q->arg1)) {
        loadOpd(&q->arg1, "x10");
    }
    /*
     * ra está em 0(sp) porque o CALLER o salvou lá.
     * O sp atual aponta para ra do caller.
     */
    emit("    jalr x0, x1, 0");
}

static void genLoad(Quadruple * q) {
    /* dest = vet[idx] */
    loadOpd(&q->arg2, "t1");
    emit("    addi t0, x0, 2");
    emit("    sll  t1, t1, t0");          /* t1 = idx * 4 */
    int baseOff = getOffset(opdName(&q->arg1));
    emit("    lw   t0, %d(x2)", baseOff);
    emit("    add  t0, t0, t1");
    emit("    lw   t2, 0(t0)");
    storeOpd(&q->result, "t2");
}

static void genStore(Quadruple * q) {
    /* vet[idx] = val */
    loadOpd(&q->arg2, "t1");
    emit("    addi t0, x0, 2");
    emit("    sll  t1, t1, t0");          /* t1 = idx * 4 */
    int baseOff = getOffset(opdName(&q->result));
    emit("    lw   t0, %d(x2)", baseOff);
    emit("    add  t0, t0, t1");
    loadOpd(&q->arg1, "t2");
    emit("    sw   t2, 0(t0)");
}

/* ============================================================
   DISPATCHER
   ============================================================ */

static void genQuad(Quadruple * q) {
    switch (q->op) {
        case OP_FUN:    genFun(q);        break;
        case OP_END:    genEnd(q);        break;
        case OP_ASSIGN: genAssign(q);     break;
        case OP_ADD:
        case OP_SUB:
        case OP_MULT:
        case OP_DIV:    genArith(q);      break;
        case OP_LT:
        case OP_GT:
        case OP_LE:
        case OP_GE:
        case OP_EQ:
        case OP_NEQ:    genRelational(q); break;
        case OP_IFF:    genIff(q);        break;
        case OP_GOTO:   genGoto(q);       break;
        case OP_LAB:    genLabel(q);      break;
        case OP_PARAM:  genParam(q);      break;
        case OP_CALL:   genCall(q);       break;
        case OP_RET:    genRet(q);        break;
        case OP_LOAD:   genLoad(q);       break;
        case OP_STORE:  genStore(q);      break;
        default:
            emit("    # OP NAO IMPLEMENTADO: %d", q->op);
            break;
    }
}

/* ============================================================
   PONTO DE ENTRADA
   ============================================================ */

void asmGen(const char * outputFile) {
    outFile = fopen(outputFile, "w");
    if (!outFile) {
        fprintf(stderr, "ERRO: nao foi possivel abrir %s\n", outputFile);
        return;
    }

    fprintf(outFile, "# Assembly RISC-V gerado pelo Compilador C-\n");
    fprintf(outFile, "# Arquitetura: RV32IM customizada\n");
    fprintf(outFile, "# I/O via MMIO: endereco 2044\n\n");

    // Stackpointer no valor máximo da memoria para decrementação da pilha
    fprintf(outFile, "    addi x2, x0, 8188\n"); //# 2047 × 4 = 8188
    fprintf(outFile, "    jal  x0, main\n\n");

    Quadruple * q = headQuad;
    while (q != NULL) {
        genQuad(q);
        q = q->next;
    }

    fclose(outFile);
    printf("\nAssembly gerado em: %s\n", outputFile);
}