# Script para apresentacao - mostra compilacao e arvore de um arquivo por vez

param([string]$arquivo = ".\testes\fatorial.cm")

$nomeBase = [System.IO.Path]::GetFileNameWithoutExtension($arquivo)
$arquivoDot = "$nomeBase.dot"
$arquivoPng = "$nomeBase.png"

Write-Host "`n================================================" -ForegroundColor Magenta
Write-Host "  COMPILADOR C-MINUS - DEMONSTRACAO" -ForegroundColor Magenta
Write-Host "================================================`n" -ForegroundColor Magenta

Write-Host "Arquivo de entrada: " -NoNewline -ForegroundColor Cyan
Write-Host "$arquivo`n" -ForegroundColor White

Write-Host "--- CODIGO FONTE ---" -ForegroundColor Yellow
Get-Content $arquivo
Write-Host ""

Write-Host "--- COMPILANDO ---" -ForegroundColor Yellow
.\compilador.exe $arquivo

Write-Host "`n--- GERANDO VISUALIZACAO ---" -ForegroundColor Yellow
.\compilador.exe $arquivo 2>&1 | Where-Object { $_ -match '^(digraph|\s|\{|\}|node|rank)' } | Out-File -Encoding ascii $arquivoDot
dot -Tpng $arquivoDot -o $arquivoPng 2>&1 | Out-Null

if (Test-Path $arquivoPng) {
    Write-Host "OK - Arvore sintatica salva em: $arquivoPng" -ForegroundColor Green
    Write-Host "`nAbrindo visualizacao..." -ForegroundColor Cyan
    Start-Process $arquivoPng
} else {
    Write-Host "ERRO ao gerar visualizacao" -ForegroundColor Red
}

Write-Host "`n================================================`n" -ForegroundColor Magenta
