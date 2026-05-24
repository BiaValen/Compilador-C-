#ifndef ASMGEN_H
#define ASMGEN_H
 
#include <stdarg.h>
 
/*
 * Gera o arquivo assembly RISC-V a partir das quádruplas
 * armazenadas em codigoIntermediario[] (codegen.h)
 *
 * outputFile: nome do arquivo .asm a ser gerado
 */
void asmGen(const char * outputFile);
 
#endif