# Golden Repo Template Bootstrap Script for Windows
param([string]$ProjectName = "")

$ErrorActionPreference = "Stop"

# Logging functions
function Write-LogError { param([string]$Message); Write-Host "[ERROR] $Message" -ForegroundColor Red }
function Write-LogInfo { param([string]$Message); Write-Host "[INFO] $Message" -ForegroundColor Blue }
function Write-LogSuccess { param([string]$Message); Write-Host "[SUCCESS] $Message" -ForegroundColor Green }

# Project setup functions
function Get-ProjectName {
    param([string]$ProvidedName)
    if ($ProvidedName) { return $ProvidedName }

    $currentDir = Split-Path -Leaf (Get-Location)
    if ($currentDir -eq "golden-repo") {
        $userInput = Read-Host "Enter project name (default: my-project)"
        return if ($userInput) { $userInput } else { "my-project" }
    }
    return $currentDir
}

function Update-ProjectMetadata {
    param([string]$ProjectName)
    Write-LogInfo "Updating metadata for: $ProjectName"

    if (Test-Path "status.json") {
        try {
            $statusData = Get-Content "status.json" | ConvertFrom-Json
            $statusData.project_name = $ProjectName
            $statusData | ConvertTo-Json -Depth 10 | Set-Content "status.json"
        } catch { }
    }
}

# Setup functions
function Install-PreCommit {
    Write-LogInfo "Setting up pre-commit..."

    if (-not (Get-Command pre-commit -ErrorAction SilentlyContinue)) {
        if (Get-Command pip3 -ErrorAction SilentlyContinue) {
            pip3 install pre-commit
        } else {
            Write-LogError "pip3 not found. Please install pre-commit manually"
            exit 1
        }
    }

    pre-commit install --install-hooks
    Write-LogSuccess "Pre-commit hooks installed"
}

function Initialize-GitRepo {
    if (-not (Test-Path ".git")) {
        Write-LogInfo "Initializing git repository..."
        try {
            git init
            git add .
            git commit -m "Initial commit from golden-repo template"
            Write-LogSuccess "Git repository initialized"
        } catch { }
    }
}

# Main function
function Main {
    Write-Host "🚀 Golden Repo Template Bootstrap" -ForegroundColor Cyan
    Write-Host "==================================" -ForegroundColor Cyan

    $detectedProjectName = Get-ProjectName -ProvidedName $ProjectName
    Write-LogInfo "Project: $detectedProjectName"

    Update-ProjectMetadata -ProjectName $detectedProjectName
    Install-PreCommit
    Initialize-GitRepo

    Write-LogSuccess "Bootstrap completed!"
    Write-LogInfo "Next steps:"
    Write-Host "  1. Update README.md"
    Write-Host "  2. Configure .github/CODEOWNERS"
    Write-Host "  3. Start developing!"
}

Main