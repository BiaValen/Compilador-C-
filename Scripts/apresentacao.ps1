# Script de Apresentacao Definitivo - C-Minus

param([string]$arquivo = ".\testes\fatorial.cm")

# Criação e direcionamento para a pasta resultados
$pastaResultados = ".\resultados"
if (-Not (Test-Path $pastaResultados)) {
    New-Item -ItemType Directory -Path $pastaResultados | Out-Null
}

$nomeBase = [System.IO.Path]::GetFileNameWithoutExtension($arquivo)
$arquivoDot = "$pastaResultados\$nomeBase.dot"
$arquivoPng = "$pastaResultados\$nomeBase.png"
$arquivoTxt = "$pastaResultados\$nomeBase_saida_completa.txt"

Write-Host "`n================================================" -ForegroundColor Magenta
Write-Host "  COMPILADOR C-MINUS - DEMONSTRACAO" -ForegroundColor Magenta
Write-Host "================================================`n" -ForegroundColor Magenta

Write-Host "Arquivo de entrada: " -NoNewline -ForegroundColor Cyan
Write-Host "$arquivo`n" -ForegroundColor White

Write-Host "--- CODIGO FONTE ---" -ForegroundColor Yellow
Get-Content $arquivo
Write-Host ""

Write-Host "--- COMPILANDO E SEPARANDO DADOS ---" -ForegroundColor Yellow
# Roda o compilador APENAS UMA VEZ e captura tudo
$saida = .\compilador.exe $arquivo 2>&1

# Salva um backup da saída completa em um arquivo TXT
$saida | Out-File -Encoding ascii $arquivoTxt

# Filtra APENAS a árvore sintática e joga direto pro arquivo .dot (escondido da tela)
$saida | Where-Object { $_ -match '^(digraph|\s*node|\s*\}|\s*->|\s*label)' -and $_ -notmatch '===' -and $_ -notmatch 'ifFalse' } | Out-File -Encoding ascii $arquivoDot

# Mostra no terminal APENAS as Quádruplas e a Tabela de Símbolos!
Write-Host "`n--- CODIGO INTERMEDIARIO E TABELA DE SIMBOLOS ---" -ForegroundColor Green
$mostrar = $true
foreach ($linha in $saida) {
    # Se começar a imprimir a Árvore Sintática, nós "escondemos" a impressão da tela
    if ($linha -match "=== ARVORE SINTATICA ===") {
        $mostrar = $false
    }
    # Quando chegar nas Quádruplas, voltamos a mostrar na tela
    if ($linha -match "=== CODIGO QUADRUPLAS") {
        $mostrar = $true
    }
    # Imprime a linha no terminal se estiver permitido
    if ($mostrar) {
        Write-Host $linha
    }
}

Write-Host "`n--- GERANDO VISUALIZACAO (AST) ---" -ForegroundColor Yellow
dot -Tpng $arquivoDot -o $arquivoPng 2>&1 | Out-Null

if (Test-Path $arquivoPng) {
    Write-Host "OK - Arvore sintatica salva em: $arquivoPng" -ForegroundColor Green
    Write-Host "OK - Relatorio textual salvo em: $arquivoTxt" -ForegroundColor Green
    Write-Host "`nAbrindo visualizacao da AST..." -ForegroundColor Cyan
    Start-Process $arquivoPng
} else {
    Write-Host "ERRO ao gerar visualizacao da arvore" -ForegroundColor Red
}

Write-Host "`n================================================`n" -ForegroundColor Magenta