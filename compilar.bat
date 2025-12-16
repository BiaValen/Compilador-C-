@echo off
C:\msys64\usr\bin\bison.exe -d sintax.y
gcc sintax.tab.c lex.yy.c util.c tabelaSimbolos.c codegen.c -o compilador.exe
if %errorlevel% equ 0 (
    echo Compilacao bem-sucedida!
) else (
    echo Erro na compilacao!
)