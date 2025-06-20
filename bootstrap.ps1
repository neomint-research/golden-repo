#requires -Version 5.1
<#
.SYNOPSIS
    Golden Repo Template Bootstrap Script for Windows

.DESCRIPTION
    Initializes a new project from the golden-repo template with proper error handling,
    project name templating, and comprehensive setup validation.

.PARAMETER ProjectName
    Optional project name. If not provided, will be detected from directory name or prompted.

.EXAMPLE
    .\bootstrap.ps1
    .\bootstrap.ps1 -ProjectName "my-awesome-project"
#>

param(
    [string]$ProjectName = ""
)

# Error handling
$ErrorActionPreference = "Stop"

# Logging functions
function Write-LogError {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor Red
}

function Write-LogWarn {
    param([string]$Message)
    Write-Host "[WARN] $Message" -ForegroundColor Yellow
}

function Write-LogInfo {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor Blue
}

function Write-LogSuccess {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor Green
}

# Project name detection
function Get-ProjectName {
    param([string]$ProvidedName)

    if ($ProvidedName) {
        return $ProvidedName
    }

    # Try to get from directory name
    $currentDir = Split-Path -Leaf (Get-Location)

    if ($currentDir -eq "golden-repo") {
        $userInput = Read-Host "Enter your project name (or press Enter for 'my-project')"
        if ([string]::IsNullOrWhiteSpace($userInput)) {
            return "my-project"
        }
        return $userInput
    }

    return $currentDir
}

# Update project metadata
function Update-ProjectMetadata {
    param([string]$ProjectName)

    Write-LogInfo "Updating project metadata for: $ProjectName"

    # Update status.json
    if (Test-Path "status.json") {
        try {
            $statusData = Get-Content "status.json" | ConvertFrom-Json
            $statusData.project_name = $ProjectName
            $statusData.lastUpdate = (Get-Date -Format "yyyy-MM-dd")
            $statusData | ConvertTo-Json -Depth 10 | Set-Content "status.json"
            Write-LogInfo "Updated status.json"
        }
        catch {
            Write-LogWarn "Could not update status.json: $($_.Exception.Message)"
        }
    }

    # Update agent.yml
    if (Test-Path "agent.yml") {
        try {
            $content = Get-Content "agent.yml" -Raw
            $content = $content -replace "identity: .*", "identity: $ProjectName"
            Set-Content "agent.yml" -Value $content
            Write-LogInfo "Updated agent.yml"
        }
        catch {
            Write-LogWarn "Could not update agent.yml: $($_.Exception.Message)"
        }
    }
}

# Check prerequisites
function Test-Prerequisites {
    Write-LogInfo "Checking prerequisites..."

    $missingTools = @()

    # Check for git
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        $missingTools += "git"
    }

    # Check for Python
    if (-not (Get-Command python -ErrorAction SilentlyContinue) -and
        -not (Get-Command python3 -ErrorAction SilentlyContinue)) {
        $missingTools += "python"
    }

    # Check for pip
    if (-not (Get-Command pip -ErrorAction SilentlyContinue) -and
        -not (Get-Command pip3 -ErrorAction SilentlyContinue)) {
        $missingTools += "pip"
    }

    if ($missingTools.Count -gt 0) {
        Write-LogError "Missing required tools: $($missingTools -join ', ')"
        Write-LogInfo "Please install the missing tools and try again"
        exit 1
    }

    Write-LogSuccess "All prerequisites satisfied"
}

# Install pre-commit
function Install-PreCommit {
    Write-LogInfo "Setting up pre-commit hooks..."

    if (-not (Get-Command pre-commit -ErrorAction SilentlyContinue)) {
        Write-LogInfo "Installing pre-commit..."

        try {
            if (Get-Command pip3 -ErrorAction SilentlyContinue) {
                pip3 install pre-commit
            } elseif (Get-Command pip -ErrorAction SilentlyContinue) {
                pip install pre-commit
            } else {
                throw "Could not find pip or pip3"
            }
        }
        catch {
            Write-LogError "Failed to install pre-commit: $($_.Exception.Message)"
            Write-LogInfo "Please install pre-commit manually: pip install pre-commit"
            exit 1
        }
    } else {
        Write-LogInfo "pre-commit already installed"
    }

    # Install hooks
    try {
        pre-commit install --install-hooks
        Write-LogSuccess "Pre-commit hooks installed successfully"
    }
    catch {
        Write-LogError "Failed to install pre-commit hooks: $($_.Exception.Message)"
        exit 1
    }
}

# Run initial formatting
function Invoke-InitialFormatting {
    Write-LogInfo "Running initial code formatting..."

    try {
        pre-commit run --all-files
        Write-LogSuccess "All pre-commit checks passed"
    }
    catch {
        Write-LogWarn "Some pre-commit checks failed, but this is normal for initial setup"
        Write-LogInfo "Files have been automatically formatted where possible"
    }
}

# Initialize git repository
function Initialize-GitRepo {
    if (-not (Test-Path ".git")) {
        Write-LogInfo "Initializing git repository..."
        try {
            git init
            git add .
            git commit -m "Initial commit from golden-repo template"
            Write-LogSuccess "Git repository initialized"
        }
        catch {
            Write-LogWarn "Could not initialize git repository: $($_.Exception.Message)"
        }
    } else {
        Write-LogInfo "Git repository already exists"
    }
}

# Main function
function Main {
    try {
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host "🚀 Golden Repo Template Bootstrap" -ForegroundColor Cyan
        Write-Host "========================================" -ForegroundColor Cyan
        Write-Host

        # Get project name
        $detectedProjectName = Get-ProjectName -ProvidedName $ProjectName
        Write-LogInfo "Project name: $detectedProjectName"
        Write-Host

        # Run bootstrap steps
        Test-Prerequisites
        Update-ProjectMetadata -ProjectName $detectedProjectName
        Install-PreCommit
        Invoke-InitialFormatting
        Initialize-GitRepo

        Write-Host
        Write-Host "========================================" -ForegroundColor Green
        Write-LogSuccess "Bootstrap completed successfully!"
        Write-Host "========================================" -ForegroundColor Green
        Write-Host
        Write-LogInfo "Your project '$detectedProjectName' is ready for development"
        Write-LogInfo "Next steps:"
        Write-Host "  1. Review and customize .github/CODEOWNERS"
        Write-Host "  2. Update README.md with your project details"
        Write-Host "  3. Configure .github/dependabot.yml for your needs"
        Write-Host "  4. Start developing your amazing project!"
        Write-Host
        Write-LogInfo "For more information, see docs/example-usage.md"
    }
    catch {
        Write-LogError "Bootstrap failed: $($_.Exception.Message)"
        Write-LogInfo "Please check the error messages above and try again"
        exit 1
    }
}

# Run main function
Main