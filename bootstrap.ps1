#requires -Version 5.1
Write-Host "🚀 Initializing NEOMINT-RESEARCH project (Windows)..."

if (-not (Get-Command pre-commit -ErrorAction SilentlyContinue)) {
    Write-Host "🔧 Installing pre-commit..."
    pip install pre-commit
}

Write-Host "🧰 Installing hooks..."
pre-commit install --install-hooks

Write-Host "🎨 Running initial formatting..."
pre-commit run --all-files

Write-Host "✅ Ready to go."