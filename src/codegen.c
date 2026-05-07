#include "globals.h"
#include "codegen.h"
#include "sintax.tab.h"
#include <string.h>
#include <stdio.h>
#include <stdlib.h>

int totalQuadruplas = 0;

/* ============================================================
   PONTEIROS DA LISTA ENCADEADA DE QUÁDRUPLAS
============================================================ */
Quadruple *headQuad = NULL;
Quadruple *tailQuad = NULL;

/* ============================================================
   FUNÇÕES AUXILIARES PARA CRIAR OPERANDOS
============================================================ */

/* Cria um operando que guarda um texto (ID, TEMP ou LABEL) */
static Operand createOpdString(OpdKind kind, char *name) {
    Operand op;
    op.kind = kind;
    op.contents.name = copyString(name);
    return op;
}

/* Cria um operando que guarda um número (CONSTANTE) */
static Operand createOpdConst(int val) {
    Operand op;
    op.kind = OPD_CONST;
    op.contents.val = val;
    return op;
}

/* Cria um operando vazio */
static Operand createOpdEmpty() {
    Operand op;
    op.kind = OPD_EMPTY;
    return op;
}

/* ============================================================
   FUNÇÃO QUE EMITE E GUARDA A QUÁDRUPLA NA RAM - LISTA ENCADEADA
============================================================ */
static void emitQuadruple(Opcode op, Operand a1, Operand a2, Operand res) {
    Quadruple *q = (Quadruple *) malloc(sizeof(Quadruple));
    q->op     = op;
    q->arg1   = a1;
    q->arg2   = a2;
    q->result = res;
    q->next   = NULL;
    totalQuadruplas++;

    if (headQuad == NULL) {
        headQuad = q;
        tailQuad = q;
    } else {
        tailQuad->next = q;
        tailQuad = q;
    }
}

/* ============================================================
   CONTADORES DE TEMPORÁRIOS E LABELS
   FIX #1: buffers eram [1], causando stack corruption.
           Agora são [16], suficiente para qualquer índice.
============================================================ */
static int tmpOffset   = 0;
static int labelOffset = 0;

static char *newTemp() {
    static char buffer[16];
    /* Prefixo "_t" nunca é válido em C-Minus (identificadores não
       começam com '_'), então nunca colidirá com variáveis do usuário. */
    sprintf(buffer, "_t%d", ++tmpOffset);
    return copyString(buffer);
}

static char *newLabel() {
    static char buffer[16];                  /* FIX #1 */
    sprintf(buffer, "L%d", ++labelOffset);
    return copyString(buffer);
}

/* ============================================================
   HELPER: garante que o resultado de cGen() seja sempre um
   temporário.  Se cGen() devolveu um nome de ID (variável
   simples), emite um ASSIGN para um temp novo e retorna esse
   temp.  Assim todos os operandos das quádruplas ficam
   consistentes.
   FIX #4 / #5: ReturnK e CallK passavam IDs como OPD_TEMP.
============================================================ */
static char *ensureTemp(char *name, int isAlreadyTemp) {
    if (isAlreadyTemp) return name;          /* já é temp, ok */
    char *t = newTemp();
    emitQuadruple(OP_ASSIGN,
                  createOpdString(OPD_ID,   name),
                  createOpdEmpty(),
                  createOpdString(OPD_TEMP, t));
    return t;
}

/* ============================================================
   GERAÇÃO RECURSIVA DE QUÁDRUPLAS (Percorrendo a AST)

   Convenção de retorno:
     - ExpK/IdK simples  → devolve tree->attr.name  (é um ID)
     - ExpK/ConstK       → devolve nome do temp gerado
     - ExpK/OpK          → devolve nome do temp gerado
     - ExpK/CallK        → devolve nome do temp gerado (ou NULL p/ void)
     - StmtK / DeclK     → devolve NULL (não produz valor)

   Para saber se o retorno é ID ou TEMP, usamos o campo
   tree->isTemp que marcamos ao gerar (veja abaixo).
   Como TreeNode pode não ter esse campo, usamos uma abordagem
   mais simples: qualquer nome que começa com 't' seguido de
   dígito é considerado temporário gerado.  Caso seu TreeNode
   já tenha um campo extra, adapte conforme necessário.
============================================================ */

/* Retorna 1 se o nome é um temporário gerado ("_t<n>").
   O prefixo "_t" é impossível em identificadores C-Minus válidos,
   então não há falsos positivos com variáveis do usuário. */
static int looksLikeTemp(const char *name) {
    if (name == NULL)    return 0;
    if (name[0] != '_')  return 0;
    if (name[1] != 't')  return 0;
    int i = 2;
    if (name[i] == '\0') return 0; /* precisa de pelo menos um dígito */
    while (name[i] != '\0') {
        if (name[i] < '0' || name[i] > '9') return 0;
        i++;
    }
    return 1;
}

static char *cGen(TreeNode *tree);

static char *cGen(TreeNode *tree) {
    char *p1, *p2;
    char *label1, *label2;
    char *currentTemp;
    char *result = NULL;

    if (tree == NULL) return NULL;

    switch (tree->nodekind) {

        /* -------------------------------------------------- */
        case StmtK:
            switch (tree->kind.stmt) {

                case IfK:
                    /*
                     *   child[0] = condição
                     *   child[1] = bloco THEN
                     *   child[2] = bloco ELSE (pode ser NULL)
                     *
                     * label2 só é alocado quando há ELSE, evitando
                     * labels órfãos que pulam a numeração.
                     */
                    p1     = cGen(tree->child[0]);           /* Condição */
                    label1 = newLabel();                     /* label_else ou label_fim */

                    emitQuadruple(OP_IFF,
                                  createOpdString(OPD_TEMP,  ensureTemp(p1, looksLikeTemp(p1))),
                                  createOpdString(OPD_LABEL, label1),
                                  createOpdEmpty());

                    cGen(tree->child[1]);                    /* Bloco THEN */

                    if (tree->child[2] != NULL) {
                        /* Tem ELSE: aloca label2 só agora */
                        label2 = newLabel();                 /* label_fim */
                        emitQuadruple(OP_GOTO,
                                      createOpdString(OPD_LABEL, label2),
                                      createOpdEmpty(), createOpdEmpty());
                        emitQuadruple(OP_LAB,
                                      createOpdString(OPD_LABEL, label1),
                                      createOpdEmpty(), createOpdEmpty());
                        cGen(tree->child[2]);                /* Bloco ELSE */
                        emitQuadruple(OP_LAB,
                                      createOpdString(OPD_LABEL, label2),
                                      createOpdEmpty(), createOpdEmpty());
                    } else {
                        /* Sem ELSE: label1 é o fim do if, não precisa de label2 */
                        emitQuadruple(OP_LAB,
                                      createOpdString(OPD_LABEL, label1),
                                      createOpdEmpty(), createOpdEmpty());
                    }
                    break;

                case WhileK:
                    /*
                     * FIX #2: índices corrigidos.
                     *   child[0] = condição
                     *   child[1] = corpo do loop
                     */
                    label1 = newLabel();                     /* Início do loop */
                    label2 = newLabel();                     /* Saída do loop  */

                    emitQuadruple(OP_LAB,
                                  createOpdString(OPD_LABEL, label1),
                                  createOpdEmpty(), createOpdEmpty());

                    p1 = cGen(tree->child[0]);               /* Condição */

                    emitQuadruple(OP_IFF,
                                  createOpdString(OPD_TEMP,  ensureTemp(p1, looksLikeTemp(p1))),
                                  createOpdString(OPD_LABEL, label2),
                                  createOpdEmpty());

                    cGen(tree->child[1]);                    /* Corpo */

                    emitQuadruple(OP_GOTO,
                                  createOpdString(OPD_LABEL, label1),
                                  createOpdEmpty(), createOpdEmpty());
                    emitQuadruple(OP_LAB,
                                  createOpdString(OPD_LABEL, label2),
                                  createOpdEmpty(), createOpdEmpty());
                    break;

                case ReturnK:
                    /*
                     * FIX #4: o resultado de cGen pode ser um ID (variável
                     * simples).  Normalizamos para TEMP antes de emitir RET.
                     */
                    p1 = cGen(tree->child[0]);
                    if (p1 != NULL) {
                        char *retTemp = ensureTemp(p1, looksLikeTemp(p1));
                        emitQuadruple(OP_RET,
                                      createOpdString(OPD_TEMP, retTemp),
                                      createOpdEmpty(), createOpdEmpty());
                    } else {
                        emitQuadruple(OP_RET,
                                      createOpdEmpty(), createOpdEmpty(), createOpdEmpty());
                    }
                    break;

                case CompoundK:
                    /*
                     * FIX #6: índices corrigidos.
                     *   child[0] = declarações locais
                     *   child[1] = lista de comandos
                     */
                    cGen(tree->child[0]);                    /* Declarações locais */
                    cGen(tree->child[1]);                    /* Comandos           */
                    break;
            }
            break;

        /* -------------------------------------------------- */
        case ExpK:
            switch (tree->kind.exp) {

                case IdK:
                    if (tree->child[0] != NULL) {
                        /*
                         * É um acesso a VETOR: v[i]
                         * child[0] = expressão do índice
                         */
                        char *indexTemp = cGen(tree->child[0]);
                        indexTemp = ensureTemp(indexTemp, looksLikeTemp(indexTemp));
                        currentTemp = newTemp();
                        /* (LOAD, nome_vetor, temp_indice, temp_destino) */
                        emitQuadruple(OP_LOAD,
                                      createOpdString(OPD_ID,   tree->attr.name),
                                      createOpdString(OPD_TEMP, indexTemp),
                                      createOpdString(OPD_TEMP, currentTemp));
                        result = currentTemp;
                    } else {
                        /* Variável simples: devolve o nome direto */
                        result = tree->attr.name;
                    }
                    break;

                case ConstK:
                    currentTemp = newTemp();
                    /* (ASSIGN, valor_constante, -, temp_destino) */
                    emitQuadruple(OP_ASSIGN,
                                  createOpdConst(tree->attr.val),
                                  createOpdEmpty(),
                                  createOpdString(OPD_TEMP, currentTemp));
                    result = currentTemp;
                    break;

                case OpK:
                    if (tree->attr.op == ATRIB) {
                        /*
                         * Atribuição: lado_esq = lado_dir
                         *   child[0] = lado esquerdo  (IdK, pode ser vetor)
                         *   child[1] = lado direito   (expressão qualquer)
                         *
                         * FIX #7: índices corrigidos (eram [1] e [2]).
                         * FIX #3: lado esquerdo simples lê attr.name direto,
                         *         sem passar por cGen() para evitar gerar
                         *         um temp desnecessário.
                         */
                        TreeNode *lhs = tree->child[0];

                        if (lhs->nodekind == ExpK &&
                            lhs->kind.exp  == IdK  &&
                            lhs->child[0]  != NULL) {
                            /* Atribuição em VETOR: v[i] = expr */
                            char *indexTemp = cGen(lhs->child[0]);
                            indexTemp = ensureTemp(indexTemp, looksLikeTemp(indexTemp));
                            p2 = cGen(tree->child[1]);
                            p2 = ensureTemp(p2, looksLikeTemp(p2));
                            /* (STORE, temp_valor, temp_indice, nome_vetor) */
                            emitQuadruple(OP_STORE,
                                          createOpdString(OPD_TEMP, p2),
                                          createOpdString(OPD_TEMP, indexTemp),
                                          createOpdString(OPD_ID,   lhs->attr.name));
                            result = lhs->attr.name;
                        } else {
                            /* Atribuição simples: var = expr             */
                            /* FIX #3: lê o nome diretamente do nó IdK   */
                            p1 = lhs->attr.name;             /* nome da variável */
                            p2 = cGen(tree->child[1]);       /* valor a atribuir */
                            p2 = ensureTemp(p2, looksLikeTemp(p2));
                            /* (ASSIGN, temp_valor, -, nome_var) */
                            emitQuadruple(OP_ASSIGN,
                                          createOpdString(OPD_TEMP, p2),
                                          createOpdEmpty(),
                                          createOpdString(OPD_ID,   p1));
                            result = p1;
                        }
                    } else {
                        /*
                         * Operações binárias: aritméticas e relacionais
                         *   child[0] = operando esquerdo
                         *   child[1] = operando direito
                         */
                        p1 = cGen(tree->child[0]);
                        p1 = ensureTemp(p1, looksLikeTemp(p1));
                        p2 = cGen(tree->child[1]);
                        p2 = ensureTemp(p2, looksLikeTemp(p2));
                        currentTemp = newTemp();

                        Opcode op_selecionado = OP_ADD;
                        switch (tree->attr.op) {
                            case MAIS:   op_selecionado = OP_ADD;  break;
                            case SUB:    op_selecionado = OP_SUB;  break;
                            case MULT:   op_selecionado = OP_MULT; break;
                            case DIV:    op_selecionado = OP_DIV;  break;
                            case MENOR:  op_selecionado = OP_LT;   break;
                            case MENORIG:op_selecionado = OP_LE;   break;
                            case MAIOR:  op_selecionado = OP_GT;   break;
                            case MAIORIG:op_selecionado = OP_GE;   break;
                            case IGUALD: op_selecionado = OP_EQ;   break;
                            case DIFF:   op_selecionado = OP_NEQ;  break;
                        }
                        emitQuadruple(op_selecionado,
                                      createOpdString(OPD_TEMP, p1),
                                      createOpdString(OPD_TEMP, p2),
                                      createOpdString(OPD_TEMP, currentTemp));
                        result = currentTemp;
                    }
                    break;

                case CallK:
                    {
                        /*
                         * Itera os argumentos manualmente via sibling.
                         * O sibling de cada arg é quebrado temporariamente
                         * antes de chamar cGen(), pois cGen() já propaga
                         * sozinho para tree->sibling no final — sem isso
                         * cada argumento seria processado duas vezes.
                         */
                        TreeNode *arg = tree->child[0];
                        int nargs = 0;

                        while (arg != NULL) {
                            TreeNode *nextArg = arg->sibling; /* salva próximo */
                            arg->sibling = NULL;              /* quebra o link  */
                            char *t = cGen(arg);              /* processa só este */
                            arg->sibling = nextArg;           /* restaura o link */
                            t = ensureTemp(t, looksLikeTemp(t));
                            emitQuadruple(OP_PARAM,
                                          createOpdString(OPD_TEMP, t),
                                          createOpdEmpty(), createOpdEmpty());
                            nargs++;
                            arg = nextArg;
                        }

                        if (strcmp(tree->attr.name, "input") == 0) {
                            currentTemp = newTemp();
                            emitQuadruple(OP_CALL,
                                          createOpdString(OPD_ID,  "input"),
                                          createOpdConst(0),
                                          createOpdString(OPD_TEMP, currentTemp));
                            result = currentTemp;
                        } else if (strcmp(tree->attr.name, "output") == 0) {
                            emitQuadruple(OP_CALL,
                                          createOpdString(OPD_ID,  "output"),
                                          createOpdConst(1),
                                          createOpdEmpty());
                            result = NULL;
                        } else {
                            currentTemp = newTemp();
                            emitQuadruple(OP_CALL,
                                          createOpdString(OPD_ID,  tree->attr.name),
                                          createOpdConst(nargs),
                                          createOpdString(OPD_TEMP, currentTemp));
                            result = currentTemp;
                        }
                    }
                    break;
            }
            break;

        /* -------------------------------------------------- */
        case DeclK:
            if (tree->kind.decl == FunK) {
                /*
                 *   child[0] = parâmetros (lista de ParamK)
                 *   child[1] = corpo (CompoundK)
                 */
                char *tipo_retorno = (tree->type == Integer) ? "int" : "void";
                emitQuadruple(OP_FUN,
                              createOpdString(OPD_ID, tipo_retorno),
                              createOpdString(OPD_ID, tree->attr.name),
                              createOpdEmpty());

                cGen(tree->child[1]);                        /* Corpo da função */

                emitQuadruple(OP_END,
                              createOpdString(OPD_ID, tree->attr.name),
                              createOpdEmpty(), createOpdEmpty());

            } else if (tree->kind.decl == VarK) {
                /*
                 * Declaração de vetor: child[0] é o ConstK com o tamanho.
                 * Variável simples (child[0] == NULL) não emite ALLOC em
                 * C-Minus — o espaço é reservado implicitamente pelo frame.
                 *
                 *   int vet[10];  →  (ALLOC, vet, 10, -)
                 */
                if (tree->child[0] != NULL) {
                    emitQuadruple(OP_ALLOC,
                                  createOpdString(OPD_ID,  tree->attr.name),
                                  createOpdConst(tree->child[0]->attr.val),
                                  createOpdEmpty());
                }
            }
            /* ParamK: os parâmetros são declarados pela própria
               convenção de chamada; não emitimos quádrupla extra. */
            break;
    }

    /* Avança para o próximo nó irmão */
    cGen(tree->sibling);
    return result;
}

/* ============================================================
   MÓDULOS DE IMPRESSÃO
============================================================ */
static void printOperand(Operand op) {
    if      (op.kind == OPD_EMPTY) printf("-");
    else if (op.kind == OPD_CONST) printf("%d", op.contents.val);
    else                           printf("%s", op.contents.name);
}

static void printOpcode(Opcode op) {
    switch (op) {
        case OP_ADD:   printf("ADD");   break;
        case OP_SUB:   printf("SUB");   break;
        case OP_MULT:  printf("MULT");  break;
        case OP_DIV:   printf("DIV");   break;
        case OP_LT:    printf("LT");    break;
        case OP_LE:    printf("LE");    break;
        case OP_GT:    printf("GT");    break;
        case OP_GE:    printf("GE");    break;
        case OP_EQ:    printf("EQ");    break;
        case OP_NEQ:   printf("NEQ");   break;
        case OP_ASSIGN:printf("ASSIGN");break;
        case OP_LOAD:  printf("LOAD");  break;
        case OP_STORE: printf("STORE"); break;
        case OP_ALLOC: printf("ALLOC"); break;
        case OP_LAB:   printf("LAB");   break;
        case OP_GOTO:  printf("GOTO");  break;
        case OP_IFF:   printf("IFF");   break;
        case OP_FUN:   printf("FUN");   break;
        case OP_ARG:   printf("ARG");   break;
        case OP_PARAM: printf("PARAM"); break;
        case OP_CALL:  printf("CALL");  break;
        case OP_RET:   printf("RET");   break;
        case OP_END:   printf("END");   break;
        case OP_HALT:  printf("HALT");  break;
        default:       printf("?");     break;
    }
}

static void printIntermediateCode() {
    Quadruple *curr = headQuad;
    int line = 1;
    while (curr != NULL) {
        printf("%3d: (", line++);
        printOpcode(curr->op);
        printf(", ");
        printOperand(curr->arg1);
        printf(", ");
        printOperand(curr->arg2);
        printf(", ");
        printOperand(curr->result);
        printf(")\n");
        curr = curr->next;
    }
}

/* ============================================================
   PONTO DE ENTRADA DO GERADOR DE CÓDIGO
============================================================ */
void codeGen(TreeNode *syntaxTree, char *codefile) {
    printf("\n=== CODIGO INTERMEDIARIO (QUADRUPLAS - LISTA ENCADEADA) ===\n\n");

    headQuad        = NULL;
    tailQuad        = NULL;
    totalQuadruplas = 0;

    cGen(syntaxTree);

    printIntermediateCode();

    printf("\nTotal de quadruplas geradas: %d\n", totalQuadruplas);
}