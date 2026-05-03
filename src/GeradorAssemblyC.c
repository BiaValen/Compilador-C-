void gerarAssembly(Quadruple* inicio) {
    Quadruple* atual = inicio;
    
    // Percorre a lista de quádruplas até o fim
    while(atual != NULL) {
        
        switch(atual->op) {
            
            case OP_MULT:
                // 1. Descobrimos em quais gavetas os dados moram
                int end1 = getOffset(atual->arg1.contents.name);   // ex: descobre que 'resultado' é 0
                int end2 = getOffset(atual->arg2.contents.name);   // ex: descobre que 'n' é 4
                int endRes = getOffset(atual->result.contents.name); // ex: descobre que 't4' é 8
                
                // 2. Imprimimos as instruções RISC-V na tela ou num arquivo .asm
                // lw = Load Word (Puxa da memória para o rascunho)
                printf("lw x5, %d(x0)\n", end1); 
                printf("lw x6, %d(x0)\n", end2); 
                
                // mul = Multiplica os dois rascunhos e salva no rascunho x7
                printf("mul x7, x5, x6\n");      
                
                // sw = Store Word (Guarda o resultado final na memória)
                printf("sw x7, %d(x0)\n", endRes);
                break;
                
            case OP_ADD:
                // A lógica é IDÊNTICA a de cima, só muda a instrução do meio para "add x7, x5, x6"
                break;
                
            // ... (aqui virão os outros cases como OP_IFF, OP_GOTO, etc) ...
        }
        
        // Pula para a próxima quádrupla da lista
        atual = atual->next;
    }
}