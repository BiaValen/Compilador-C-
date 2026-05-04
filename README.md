# Compilador C- (C Minus)

Implementação de um compilador completo para a linguagem C- (C Minus), uma linguagem simplificada baseada em C, desenvolvida como projeto final da disciplina de Compiladores.

---

## Funcionalidades Implementadas

### Análise Léxica
- **Tokens reconhecidos:**
  - Palavras-chave: `if`, `else`, `while`, `return`, `int`, `void`
  - Operadores aritméticos: `+`, `-`, `*`, `/`
  - Operadores relacionais: `<`, `<=`, `>`, `>=`, `==`, `!=`
  - Operador de atribuição: `=`
  - Delimitadores: `(`, `)`, `{`, `}`, `[`, `]`, `;`, `,`
  - Identificadores (variáveis e funções)
  - Números inteiros
  - Comentários de bloco `/* ... */`
- **Detecção de erros léxicos** com mensagem de linha

### Análise Sintática
- Construção de **Árvore Sintática Abstrata (AST)**
- Suporte completo à gramática C-:
  - Declarações de variáveis (`int x;`, `int v[10];`)
  - Declarações de funções com parâmetros
  - Estruturas de controle: `if/else`, `while`
  - Expressões aritméticas e relacionais
  - Chamadas de função
  - Comando `return`
- **Detecção de erros sintáticos** com mensagens descritivas
- Resolução do conflito dangling-else

### Tabela de Símbolos
- Armazena informações de:
  - **Variáveis:** nome, tipo, escopo, localização na memória
  - **Funções:** nome, tipo de retorno, parâmetros
  - **Vetores:** nome, tipo, tamanho
- Controle de **escopo** (global e local)
- Exibição formatada em tabela

### Geração de Código Intermediário (Quádruplas)
O compilador gera código intermediário no formato de **quádruplas** `(op, arg1, arg2, resultado)`, armazenadas em um array global para posterior tradução para assembly.

**Instruções geradas:**

| Instrução | Formato | Descrição |
|---|---|---|
| Entrada de função | `(FUN, tipo, nome, -)` | Marca início de função |
| Fim de função | `(END, nome, -, -)` | Marca fim de função |
| Atribuição | `(ASSIGN, val, -, dest)` | `dest = val` |
| Soma | `(ADD, a, b, dest)` | `dest = a + b` |
| Subtração | `(SUB, a, b, dest)` | `dest = a - b` |
| Multiplicação | `(MULT, a, b, dest)` | `dest = a * b` |
| Divisão | `(DIV, a, b, dest)` | `dest = a / b` |
| Menor que | `(LT, a, b, dest)` | `dest = a < b` |
| Menor ou igual | `(LE, a, b, dest)` | `dest = a <= b` |
| Maior que | `(GT, a, b, dest)` | `dest = a > b` |
| Maior ou igual | `(GE, a, b, dest)` | `dest = a >= b` |
| Igual | `(EQ, a, b, dest)` | `dest = a == b` |
| Diferente | `(NEQ, a, b, dest)` | `dest = a != b` |
| Desvio condicional | `(IFF, cond, label, -)` | Se falso, salta para label |
| Desvio incondicional | `(GOTO, label, -, -)` | Salta para label |
| Rótulo | `(LAB, label, -, -)` | Define um ponto de salto |
| Parâmetro | `(PARAM, arg, -, -)` | Empilha argumento |
| Chamada de função | `(CALL, func, nargs, dest)` | Chama função |
| Retorno | `(RET, val, -, -)` | Retorna valor |
| Leitura de vetor | `(LOAD, vet, idx, dest)` | `dest = vet[idx]` |
| Escrita em vetor | `(STORE, val, idx, vet)` | `vet[idx] = val` |

- Variáveis temporárias geradas automaticamente: `t1`, `t2`, `t3`, ...
- Rótulos gerados automaticamente: `L1`, `L2`, `L3`, ...
- Quádruplas armazenadas em `codigoIntermediario[]` (array global, máx. 1000 instruções)

### Bônus: Visualização Gráfica
- Geração automática da AST em formato **Graphviz (DOT)**
- Scripts PowerShell para visualização automática
- Conversão para imagens PNG

---

## Compilação

### Pré-requisitos
- **Windows** com PowerShell
- **Bison 3.x** (instalado em `C:\msys64\usr\bin\bison.exe`)
- **Flex** (lexer)
- **GCC** (MinGW)
- **Graphviz** (opcional, para visualização)

### Compilar o Compilador

```powershell
.\Scripts\compilar.bat
```

Este script executa:
1. `bison -d sintax.y` → Gera `sintax.tab.c` e `sintax.tab.h`
2. Compila todos os arquivos: `sintax.tab.c`, `lex.yy.c`, `util.c`, `tabelaSimbolos.c`, `codegen.c`
3. Cria o executável `compilador.exe`

---

## Uso

### Compilar um programa C-

```powershell
.\compilador.exe .\testes\fatorial.cm
```

**Saída:**
- **Árvore Sintática** (formato Graphviz DOT)
- **Código Intermediário em Quádruplas**
- **Tabela de Símbolos**

### Modo Apresentação (com visualização)

```powershell
.\Scripts\apresentacao.ps1 .\testes\fatorial.cm
```

Exibe:
- Código fonte
- Compilação completa
- **Abre automaticamente** a imagem PNG da árvore sintática

### Processar Todos os Testes

```powershell
.\testar_todos.ps1
```

Gera imagens PNG para todos os arquivos `.cm` em `testes/`

---

## Gramática Suportada

### Tipos de Dados
- `int` — Inteiros
- `void` — Vazio (apenas para funções)

### Declarações

**Variáveis:**
```c
int x;           // Variável simples
int v[10];       // Vetor
```

**Funções:**
```c
int funcao(int a, int b) {
    // corpo
}

void procedimento(void) {
    // corpo
}
```

### Comandos

**Atribuição:**
```c
x = 10;
v[5] = x + 2;
```

**Estruturas de Controle:**
```c
if (x > 0) {
    return 1;
} else {
    return 0;
}

while (n > 1) {
    n = n - 1;
}
```

**Retorno:**
```c
return x;
return;
```

### Expressões

**Operadores Aritméticos:** `+`, `-`, `*`, `/`

**Operadores Relacionais:** `<`, `<=`, `>`, `>=`, `==`, `!=`

**Chamadas de Função:**
```c
resultado = fatorial(5);
```

---

## Exemplos de Programas

### Exemplo 1: Fatorial

```c
int fatorial(int n) {
    int resultado;
    resultado = 1;
    while (n > 1) {
        resultado = resultado * n;
        n = n - 1;
    }
    return resultado;
}

void main(void) {
    int x;
    x = input();
    output(fatorial(x));
}
```

**Quádruplas geradas:**
```
(FUN, int, fatorial, -)
(ASSIGN, 1, -, t1)
(ASSIGN, t1, -, resultado)
(LAB, L1, -, -)
(ASSIGN, 1, -, t2)
(GT, n, t2, t3)
(IFF, t3, L2, -)
(MULT, resultado, n, t4)
(ASSIGN, t4, -, resultado)
(ASSIGN, 1, -, t5)
(SUB, n, t5, t6)
(ASSIGN, t6, -, n)
(GOTO, L1, -, -)
(LAB, L2, -, -)
(RET, resultado, -, -)
(END, fatorial, -, -)
(FUN, void, main, -)
(CALL, input, 0, t7)
(ASSIGN, t7, -, x)
(PARAM, x, -, -)
(CALL, fatorial, 1, t8)
(PARAM, t8, -, -)
(CALL, output, 1, -)
(END, main, -, -)
```

### Exemplo 2: MDC (Algoritmo de Euclides)

```c
int gcd(int u, int v) {
    if (v == 0) { return u; }
    else return gcd(v, u - u/v*v);
}

void main(void) {
    int x; int y;
    x = input();
    y = input();
    output(gcd(x, y));
}
```

**Quádruplas geradas:**
```
(FUN, int, gcd, -)
(ASSIGN, 0, -, t1)
(EQ, v, t1, t2)
(IFF, t2, L1, -)
(RET, u, -, -)
(GOTO, L2, -, -)
(LAB, L1, -, -)
(PARAM, v, -, -)
(DIV, u, v, t3)
(MULT, t3, v, t4)
(SUB, u, t4, t5)
(PARAM, t5, -, -)
(CALL, gcd, 2, t6)
(RET, t6, -, -)
(LAB, L2, -, -)
(END, gcd, -, -)
(FUN, void, main, -)
(CALL, input, 0, t7)
(ASSIGN, t7, -, x)
(CALL, input, 0, t8)
(ASSIGN, t8, -, y)
(PARAM, x, -, -)
(PARAM, y, -, -)
(CALL, gcd, 2, t9)
(PARAM, t9, -, -)
(CALL, output, 1, -)
(END, main, -, -)
```

---

## Tratamento de Erros

### Erros Léxicos
```
ERRO LEXICO: '@' - LINHA: 1
```

### Erros Sintáticos
```
ERRO SINTATICO na linha 3: syntax error
```

### Erros Semânticos
```
ERRO SEMANTICO: variavel 'x' nao declarada - LINHA: 5
```

---

## Arquitetura do Projeto

```
.
├── lexer.l              # Analisador léxico (Flex)
├── sintax.y             # Analisador sintático (Bison)
├── globals.h            # Tipos e estruturas globais (TreeNode, etc.)
├── util.c / util.h      # Funções auxiliares da AST
├── tabelaSimbolos.c     # Tabela de símbolos com escopo
├── codegen.c            # Gerador de código intermediário (quádruplas)
├── codegen.h            # Struct Quadrupla e array codigoIntermediario[]
├── testes/              # Programas C- de teste
├── resultados/          # Saídas geradas (PNG, TXT)
└── Scripts/
    ├── compilar.bat     # Script de compilação
    └── apresentacao.ps1 # Script de apresentação com visualização
```

### Fluxo de Compilação

```
Código Fonte (.cm)
      |
      v
   [Lexer]          lexer.l        -> Tokens
      |
      v
   [Parser]         sintax.y       -> AST
      |
      v
[Tabela Símbolos]   tabelaSimbolos.c -> Escopos e tipos
      |
      v
[Gerador Código]    codegen.c      -> Quádruplas[]
```

---

## Desenvolvimento

### Tecnologias Utilizadas
- **Bison 3.8.2** — Gerador de parser LALR(1)
- **Flex** — Gerador de analisador léxico
- **GCC (MinGW)** — Compilador C
- **PowerShell** — Scripts de automação
- **Graphviz** — Visualização da AST

---

## Referência

Compilador baseado na especificação da linguagem C- definida em:
> LOUDEN, Kenneth C. *Compiler Construction: Principles and Practice*. PWS Publishing, 1997.