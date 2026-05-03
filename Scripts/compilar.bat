@echo off
echo ==================================================
echo       COMPILADOR C-MINUS - SCRIPT DE BUILD
echo ==================================================

:: Injeta os caminhos mais comuns de compiladores diretamente nesta execucao
set PATH=C:\msys64\usr\bin;C:\msys64\mingw64\bin;C:\MinGW\bin;C:\MinGW\msys\1.0\bin;C:\GnuWin32\bin;C:\FlexWindows\bin;%PATH%

set "ROOT_DIR=%~dp0.."
set "SRC_DIR=%~dp0..\src"

echo [0/3] Entrando na pasta de codigo-fonte...
cd /d "%SRC_DIR%"

echo [1/3] Gerando o Analisador Sintatico (Bison)...
bison -d sintax.y

echo [2/3] Gerando o Analisador Lexico (Flex)...
flex lexer.l

echo [3/3] Compilando o codigo fonte (GCC)...
gcc sintax.tab.c lex.yy.c tabelaSimbolos.c codegen.c util.c -o "%ROOT_DIR%\compilador.exe"

cd /d "%ROOT_DIR%"

echo ==================================================
echo FIM DA COMPILACAO! Verifique se o compilador.exe foi gerado na raiz.
echo ==================================================
pause