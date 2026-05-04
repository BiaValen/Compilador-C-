#include "codegen.h"

void gerarAssembly() {
    for (int i = 0; i < totalQuadruplas; i++) {
        Quadrupla q = codigoIntermediario[i];

        if (strcmp(q.op, "ADD") == 0) {
            printf("MOV R0, %s\n", q.arg1);
            printf("ADD R0, %s\n", q.arg2);
            printf("MOV %s, R0\n", q.result);
        }
        else if (strcmp(q.op, "ASSIGN") == 0) {
            printf("MOV %s, %s\n", q.result, q.arg1);
        }
        /* ... continuar */
    }
}