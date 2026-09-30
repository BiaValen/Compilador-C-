@echo off
:: Roda o pipeline completo: .cm -> saida.asm -> program.hex/program.bin
:: e limpa o cache de smart compilation do Quartus, que fica com estado
:: velho toda vez que o conteudo do program.hex muda.
::
:: Uso:
::   Scripts\compilar_fpga.bat tests\fibonacci.cm

setlocal
set "ROOT_DIR=%~dp0.."
set "CM_FILE=%~1"

if "%CM_FILE%"=="" (
    echo Uso: compilar_fpga.bat caminho\para\arquivo.cm
    exit /b 1
)

cd /d "%ROOT_DIR%"

echo ==================================================
echo [1/3] Compilando %CM_FILE% -> saida.asm
echo ==================================================
compilador.exe "%CM_FILE%"
if %errorlevel% neq 0 (
    echo Erro ao compilar %CM_FILE%
    exit /b 1
)

echo ==================================================
echo [2/3] Montando saida.asm -> RISC-V\program.hex / program.bin
echo ==================================================
python RISC-V\sinteses\asm_to_hex.py saida.asm RISC-V\program.hex --bin RISC-V\program.bin
if %errorlevel% neq 0 (
    echo Erro ao montar saida.asm
    exit /b 1
)

echo ==================================================
echo [3/3] Limpando cache de smart compilation do Quartus
echo ==================================================
if exist "RISC-V\db" rmdir /s /q "RISC-V\db"
if exist "RISC-V\incremental_db" rmdir /s /q "RISC-V\incremental_db"

echo ==================================================
echo PRONTO!
:: echo Dica: desmarque "Use Smart Compilation" em Assignments ^> Settings ^>
:: echo Compilation Process Settings pra esse cache parar de sujar sozinho.
echo ==================================================
