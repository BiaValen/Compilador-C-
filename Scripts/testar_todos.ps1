# Script para processar todos os arquivos .cm da pasta testes

Write-Host "`n=== Processando todos os testes ===" -ForegroundColor Magenta

# Obtém todos os arquivos .cm da pasta testes
$arquivos = Get-ChildItem -Path ".\testes\*.cm"

if ($arquivos.Count -eq 0) {
    Write-Host "Nenhum arquivo .cm encontrado em .\testes" -ForegroundColor Red
    exit
}

Write-Host "Encontrados $($arquivos.Count) arquivos de teste`n" -ForegroundColor Cyan

foreach ($arquivo in $arquivos) {
    $nomeBase = $arquivo.BaseName
    $caminhoCompleto = $arquivo.FullName
    $arquivoDot = "$nomeBase.dot"
    $arquivoPng = "$nomeBase.png"
    
    Write-Host "[$nomeBase]" -ForegroundColor Yellow -NoNewline
    Write-Host " Gerando arvore..." -NoNewline
    
    # Executa o compilador e extrai o grafo DOT
    .\compilador.exe $caminhoCompleto 2>&1 | Where-Object { $_ -match '^(digraph|\s|\{|\}|node|rank)' } | Out-File -Encoding ascii $arquivoDot
    
    # Gera a imagem PNG
    dot -Tpng $arquivoDot -o $arquivoPng 2>&1 | Out-Null
    
    if (Test-Path $arquivoPng) {
        Write-Host " ✓ $arquivoPng" -ForegroundColor Green
    } else {
        Write-Host " ✗ Erro" -ForegroundColor Red
    }
}

Write-Host "`n=== Processamento concluído ===" -ForegroundColor Magenta
Write-Host "Arquivos gerados:" -ForegroundColor Cyan
Get-ChildItem -Path "*.png" | Select-Object Name, Length, LastWriteTime | Format-Table
