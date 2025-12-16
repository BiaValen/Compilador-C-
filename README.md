# Compilador C- (C Minus)

Implementação de um compilador completo para a linguagem C- (C Minus), uma linguagem simplificada baseada em C, desenvolvida como projeto final da disciplina de Compiladores.

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

### Geração de Código Intermediário (3 Endereços)
- Instruções geradas:
  - Operações aritméticas: `t1 = a + b`
  - Operações relacionais: `t2 = x > 10`
  - Atribuições: `x = t1`
  - Desvios condicionais: `ifFalse t2 goto L1`
  - Desvios incondicionais: `goto L2`
  - Labels: `label L1`
  - Chamadas de função: `t3 = call func, 2`
  - Parâmetros: `param x`
  - Retorno: `return t1`
  - Entrada de função: `_entry main`
- Variáveis temporárias: `t1`, `t2`, `t3`, ...
- Labels automáticos: `L1`, `L2`, `L3`, ...

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
.\compilar.bat
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
- **Código Intermediário de 3 Endereços**
- **Tabela de Símbolos**

### Modo Apresentação (com visualização)

```powershell
.\apresentacao.ps1 .\testes\fatorial.cm
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

## Estrutura do Projeto

```
Compilador-C-/
├── compilar.bat              # Script de compilação
├── apresentacao.ps1          # Script de apresentação interativa
├── testar_todos.ps1          # Processa todos os testes
├── gerar_arvore.ps1          # Gera visualização individual
│
├── lexer.l                   # Especificação do analisador léxico (Flex)
├── sintax.y                  # Gramática e parser (Bison)
├── globals.h                 # Definições globais e estrutura da AST
├── util.h / util.c           # Funções auxiliares (criação de nós, impressão)
├── tabelaSimbolos.h / .c     # Implementação da tabela de símbolos
├── codegen.h / codegen.c     # Geração de código intermediário
│
└── testes/
    ├── fatorial.cm           # Teste com while e chamada de função
    ├── soma.cm               # Teste com função com parâmetros
    ├── simples.cm            # Programa mínimo válido
    ├── valido.cm             # Teste completo válido
    ├── erro_lexico.cm        # Teste de erro léxico
    ├── erro_sintatico1.cm    # Teste de erro sintático
    └── erro_sintatico2.cm    # Outro erro sintático
```

---

## Gramática Suportada

### Tipos de Dados
- `int` - Inteiros
- `void` - Vazio (apenas para funções)

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

**Operadores Aritméticos:**
- `+` (adição)
- `-` (subtração)
- `*` (multiplicação)
- `/` (divisão)

**Operadores Relacionais:**
- `<`, `<=`, `>`, `>=`, `==`, `!=`

**Chamadas de Função:**
```c
resultado = fatorial(5);
```

---

## Exemplos de Programas

### Exemplo 1: Fatorial
```c
/* Calcula o fatorial usando while */
int fatorial(int n) {
    int resultado;
    resultado = 1;
    
    while (n > 1) {
        resultado = resultado * n;
        n = n - 1;
    }
    
    return resultado;
}

int main(void) {
    int x;
    x = fatorial(5);
    return x;
}
```

**Código intermediário gerado:**
```
_entry fatorial
t1 = 1
resultado = t1
label L1
t2 = 1
t3 = n > t2
ifFalse t3 goto L2
t4 = resultado * n
resultado = t4
t5 = 1
t6 = n - t5
n = t6
goto L1
label L2
return resultado

_entry main
t7 = 5
param t7
t8 = call fatorial, 1
x = t8
return x
```

### Exemplo 2: Soma
```c
int soma(int a, int b) {
    return a + b;
}

int main(void) {
    int resultado;
    resultado = soma(5, 3);
    return resultado;
}
```

---

## Tratamento de Erros

### Erros Léxicos
```c
int x = @;  // ERRO LEXICO: '@' - LINHA: 1
```

### Erros Sintáticos
```c
int main(void) {
    x = 10;  // ERRO SINTATICO: 'x' não declarado (falta 'int x;')
}
```

---

## Desenvolvimento

### Tecnologias Utilizadas
- **Bison 3.8.2** - Gerador de parser
- **Flex** - Gerador de lexer
- **GCC (MinGW)** - Compilador C
- **PowerShell** - Scripts de automação
- **Graphviz** - Visualização de grafos

### Arquitetura
1. **Lexer** (`lexer.l`) → Tokens
2. **Parser** (`sintax.y`) → AST
3. **Tabela de Símbolos** (`tabelaSimbolos.c`) → Armazena declarações
4. **Gerador de Código** (`codegen.c`) → Código de 3 endereços


---

## Nota

- O compilador segue a especificação da linguagem C- definida no livro "Compiler Construction: Principles and Practice" (Kenneth C. Louden)
