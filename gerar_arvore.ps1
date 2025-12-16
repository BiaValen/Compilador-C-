param([string]$arquivo = ".\testes\fatorial.cm")

# Extrai o nome base do arquivo (sem extensão e caminho)
$nomeBase = [System.IO.Path]::GetFileNameWithoutExtension($arquivo)
$arquivoDot = "$nomeBase.dot"
$arquivoPng = "$nomeBase.png"

Write-Host "Processando $arquivo..." -ForegroundColor Cyan

.\compilador.exe $arquivo 2>&1 | Where-Object { $_ -match '^(digraph|\s|\{|\}|node|rank)' } | Out-File -Encoding ascii $arquivoDot
dot -Tpng $arquivoDot -o $arquivoPng 2>&1 | Out-Null

if (Test-Path $arquivoPng) {
    Write-Host "✓ Arvore gerada: $arquivoPng" -ForegroundColor Green
    Start-Process $arquivoPng
} else {
    Write-Host "✗ Erro ao gerar arvore" -ForegroundColor Red
}
