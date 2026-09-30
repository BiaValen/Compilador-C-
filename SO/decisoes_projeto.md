# Log de decisoes e mudancas pendentes - Projeto SO

Arquivo de acompanhamento. Cada item tem: o que foi decidido/achado, por que, e o que ainda falta fazer no codigo (se falta).

## 1. Boot: BIOS, seletor de busca, instrucao de troca

- **Decisao:** BIOS e um bloco de **hardware** (ROM propria), nao faz parte da camada de software junto com o SO.
- **Decisao:** existe um **Seletor** (mux) explicito entre BIOS e memoria de instrucoes, que decide de onde o processador busca a proxima instrucao.
- **Decisao:** a instrucao que troca a fonte de busca (BIOS -> memoria de instrucoes) e salta pro inicio do SO se chama **`JMP_SO`** (nome sujeito a mudar, ver alternativas: `BOOT_SO`, `SWITCH_SO`).
- **Decisao:** `LW_hd`/`SW_hd` sao usadas **duas vezes** com donos diferentes: BIOS usa uma vez no boot (copia o SO inteiro do HD); o SO usa de novo em runtime, toda vez que o shell carrega um programa de usuario.
- **Decisao:** BIOS conhece por constante fixa onde o SO comeca no HD (endereco 0) e por constante fixa o tamanho do SO (nao ha marcador de fim).
- **Pendente:** nenhuma mudanca de codigo ainda - isso ainda e etapa de especificacao/relatorio (PC2), nao implementacao.

## 2. Tamanho do slot de instrucao por programa no HD: 400 palavras

- **Por que:** medi (compilando + contando linhas de asm) os 10 testes do PC1. Maior atual: `sort.cm` com 300 linhas. 400 da ~33% de margem.
- **Pendente:** nenhuma mudanca de codigo ainda (parametro a ser usado quando o HD simulado for implementado em Verilog).

## 3. Memoria de dados: expandida de 2048 -> 2816 palavras, 11 particoes de 256

- **Por que:** medi via simulacao (RV32IM, `simriscv.py` instrumentado) o uso real de pilha dos 10 testes. Pior caso: `fibonacci.cm` (`fib(9)`, recursao em arvore) usa 148 palavras. 256 e a proxima potencia de 2 acima disso - da margem e permite calcular offset por deslocamento de bits (`indice << 8`).
- **11 particoes** = 10 processos de usuario (limite do projeto) + 1 para o SO.
- **Custo:** ~2,25% da FPGA (estimativa), considerado desprezivel.
- **Pendente:** nenhuma mudanca de codigo ainda (a memoria de dados ainda nao foi expandida no Verilog).

## 4. Conflito de endereco MMIO com a memoria de dados expandida

- **Achado:** `input()` (endereco 2044) e `output()` (endereco 2040) caem **dentro** da nova faixa de memoria de dados (0-2815), especificamente na particao 7. Um processo usando essa particao inteira colidiria com os enderecos de E/S.
- **Correcao de um dado errado:** o display **nao** esta em `0xFFFF0004` - conferido em `decoder_mmio_output.v`, esta em 2040 (mesmo problema que input).
- **Por que nao da pra usar um endereco alto tipo `0xFFFF0004` direto:** nao existe instrucao `lui` (nem equivalente) no processador - enderecos grandes nao sao alcancaveis num unico imediato de 12 bits.
- **Solucao escolhida:** usar **imediatos negativos pequenos**, que o `extensor.v` ja estende com sinal (`{{20{instr[31]}}, instr[31:20]}`). Ou seja, `-4` vira `0xFFFFFFFC` e `-8` vira `0xFFFFFFF8` - enderecos altos, de graca, sem hardware novo.
- **Nova proposta de enderecos:** `input()` -> `-4` (0xFFFFFFFC); `output()` -> `-8` (0xFFFFFFF8).
- **Pendente (codigo, ainda nao aplicado):**
  - `RISC-V/sinteses/decoder_mmio_input.v` - mudar `INPUT_ADDR` de `32'd2044` para o novo valor
  - `RISC-V/sinteses/decoder_mmio_output.v` - mudar `DISPLAY_ADDR` de `32'd2040` para o novo valor
  - `RISC-V/sinteses/RISCV_processador.v` - mesma constante `INPUT_ADDR`/`DISPLAY_ADDR` usada no calculo de `input_stall`/`display_write_internal` (linhas ~75, ~102)
  - `src/asmgen.c` - onde gera `lw t0, 2044(x0)` / `sw ..., 2040(x0)` fixo pro `input()`/`output()`
  - `simriscv.py` - **bug**: `mem_read`/`mem_write` fazem `idx = addr // 4` e rejeitam indice negativo com erro, em vez de mascarar pra endereco unsigned de 32 bits (`addr & 0xFFFFFFFF`) como o hardware real faria. Precisa corrigir pra simulacao continuar funcionando com os novos enderecos negativos.

## 5. Sistema de arquivos: alocacao continua + tabela de diretorio [FECHADO]

- **Decisao:** alocacao continua, tabela de diretorio em posicao fixa do HD, logo apos a regiao do SO.
- **Simplificacao:** como os programas ja usam **slot de tamanho fixo** (400 palavras, item 2), a entrada de diretorio nao guarda inicio+tamanho - so **nome + flag de ocupado**. O indice da entrada na tabela = indice do slot no HD (inicio do slot = `TAMANHO_SO + indice x 400`), sem precisar armazenar o indice.
- **Numero maximo de programas no HD: 16** (o dobro do limite de 10 processos simultaneos - da folga real pra criar/renomear/deletar sem lotar).
- **Layout do HD:** `[SO: TAMANHO_SO palavras][tabela de diretorio: 16 entradas][16 slots de programa x 400 palavras = 6400 palavras]`.
- **Entrada de diretorio (proposta):** nome de ate 8 caracteres (2 palavras, 4 caracteres ASCII por palavra) + 1 palavra de flag (livre/ocupado) = 3 palavras/entrada x 16 = 48 palavras pra tabela inteira. Ajustavel se precisar de nomes maiores.

## 6. Memoria de instrucoes: SO com particao maior (2048) + 10 particoes de usuario (512) [FECHADO - revisado]

- **Decisao final (revisada):** abandonada a ideia de 2 regioes com recarregamento a cada troca de contexto. Memoria de instrucoes tem particionamento fixo, mas **a particao do SO NAO tem o mesmo tamanho** das particoes de usuario.
- **Por que revisar:** um projeto de referencia (relatorio do Victor, consultado informalmente, nao citado no relatorio final por nao ser fonte academica) registra uma BIOS que copia 1880 instrucoes do SO - muito acima de 512 palavras. O proprio SO (escalonador + troca de contexto + tabela de diretorio + shell) tende a nao caber em 512.
- **Esquema final:** particao do SO = **2048 palavras** (mesmo teto ja reservado pro SO no HD, item 9), 10 particoes de usuario = **512 palavras cada**.
- **Por que 512 e nao 400 pras particoes de usuario:** 400 nao e potencia de 2, quebraria o deslocamento de bits (`indice << 9`). Os slots do HD continuam em 400 palavras - so se copiam 400 palavras pra dentro de uma particao de 512.
- **Total memoria de instrucoes:** 2048 + 10x512 = **7168 palavras** (nao mais 5632 - numero antigo ficou incorreto, corrigido).
- **Custo combinado:** memoria de instrucoes (7168) + memoria de dados (2816) = 9984 palavras novas no total, ~6,1% da FPGA (recalculado; a estimativa antiga de 2,3%/4,5% isoladas ficou desatualizada).
- **Consequencia:** cada processo mantem seu codigo residente na propria particao depois de carregado uma vez - sem recarregamento a cada troca de contexto.

## 7. Preempcao durante espera de input - CONFIRMADO: nao e possivel

- **Achado (verificado direto no Verilog):** `RISCV_processador.v` tem `input_stall = MemRead && (alu_result==INPUT_ADDR) && !data_is_ready_from_input`, e `pc_stall = input_stall || output_stall`. O PC so avanca se `!pc_stall` (`.enable(!pc_stall)`).
- **Conclusao:** enquanto um processo espera o botao Enter, o PC fica **travado no hardware**. Nao ha nenhuma logica que permita ao temporizador/quantum interromper esse estado.
- **Implicacao:** um processo esperando `input()` **bloqueia todos os outros processos** - o Round Robin nao consegue trocar de contexto nesse caso. Isso e uma limitacao real do design atual, nao um bug - mas **precisa ser documentada explicitamente** na secao de gerenciamento de E/S do relatorio (ver ficha do PC2, item 13).


## 8. Quantum: 1000 ciclos [FECHADO]

- **Decisao final:** quantum = 1000 ciclos de clock.
- **Custo da troca de contexto:** ~70 ciclos (31 registradores x1-x31, 1 sw+1 lw cada, processador monociclo). Sem custo de recarregar do HD, ja que cada processo tem particao propria de instrucao residente (item 6).
- **Overhead:** ~7% (70/1000), seguindo a diretriz de quantum >> custo da troca (~10x).
- **Validacao cruzada com relatorios de exemplo (Thiago, Victor):** ambos usam quantum bem menor (50 instrucoes / configuravel, ex. 30 ciclos), mas os dois recarregam codigo do HD a cada troca de contexto - custo que este projeto nao tem. Ou seja, os exemplos otimizam para facilidade de demonstracao (troca rapida e visivel), nao para eficiencia.
- **Clock real do processador: 500 Hz** (clock de 50MHz da placa dividido por 100.000 no `clock_divider` - conferido em `toplevel.v`, DIVISOR ativo e 100_000, nao o 50_000_000 comentado ao lado, que daria 1Hz).
- **Tempo real de demonstracao:** quantum de 1000 ciclos a 500Hz = 2 segundos por troca de contexto - viavel dentro da janela de ~5 minutos de demonstracao ao vivo, com folga pra mostrar varias trocas.
- **Atencao:** se o DIVISOR do clock_divider for alterado pra 50_000_000 (1Hz) em algum momento, o tempo de demonstracao muda para 1000 segundos (~16min) - inviavel. Reconferir antes da demonstracao final.

## 9. Tamanho do SO no HD: 2048 palavras (estimativa) [FECHADO]

- **Decisao final:** reservar 2048 palavras pro SO no HD (estimativa de planejamento, nao medida - o SO ainda nao foi implementado).
- **Validacao cruzada:** o relatorio do Thiago (colega, mesmo projeto/disciplina) reserva exatamente 2048 posicoes pro SO no HD e usa apenas 1270 - validacao real de que 2048 e uma estimativa generosa e razoavel.
- **Nota:** valor a ser revisto apos a implementacao real do SO, caso o codigo final exceda essa reserva.
