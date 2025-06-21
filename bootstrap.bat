@echo off
REM Golden Repo Template Bootstrap Script for Windows (Batch)
setlocal enabledelayedexpansion

set "PROJECT_NAME=%~1"

REM Logging functions
:log_error
echo [ERROR] %~1
exit /b 1

:log_info
echo [INFO] %~1
exit /b 0

:log_success
echo [SUCCESS] %~1
exit /b 0

REM Project setup functions
:get_project_name
if not "%PROJECT_NAME%"=="" (
    set "DETECTED_PROJECT_NAME=%PROJECT_NAME%"
    goto :eof
)

for %%I in (.) do set "CURRENT_DIR=%%~nxI"
if "%CURRENT_DIR%"=="golden-repo" (
    set /p "USER_INPUT=Enter project name (default: my-project): "
    if "!USER_INPUT!"=="" (
        set "DETECTED_PROJECT_NAME=my-project"
    ) else (
        set "DETECTED_PROJECT_NAME=!USER_INPUT!"
    )
) else (
    set "DETECTED_PROJECT_NAME=%CURRENT_DIR%"
)
goto :eof

:update_project_metadata
call :log_info "Updating metadata for: %DETECTED_PROJECT_NAME%"
if exist "status.json" (
    REM Simple JSON update - replace project_name value
    powershell -Command "(Get-Content 'status.json') -replace '\"project_name\":\s*\"[^\"]*\"', '\"project_name\": \"%DETECTED_PROJECT_NAME%\"' | Set-Content 'status.json'" 2>nul
)
goto :eof

:install_precommit
call :log_info "Setting up pre-commit..."

where pre-commit >nul 2>&1
if %errorlevel% neq 0 (
    where pip3 >nul 2>&1
    if %errorlevel% neq 0 (
        where pip >nul 2>&1
        if %errorlevel% neq 0 (
            call :log_error "pip not found. Please install pre-commit manually"
            exit /b 1
        ) else (
            pip install pre-commit
        )
    ) else (
        pip3 install pre-commit
    )
)

pre-commit install --install-hooks
if %errorlevel% equ 0 (
    call :log_success "Pre-commit hooks installed"
) else (
    call :log_error "Failed to install pre-commit hooks"
    exit /b 1
)
goto :eof

:initialize_git_repo
if not exist ".git" (
    call :log_info "Initializing git repository..."
    git init
    if %errorlevel% equ 0 (
        git add .
        git commit -m "Initial commit from golden-repo template"
        if %errorlevel% equ 0 (
            call :log_success "Git repository initialized"
        )
    )
)
goto :eof

REM Main execution
:main
echo.
echo Golden Repo Template Bootstrap
echo ==================================
echo.

call :get_project_name
call :log_info "Project: %DETECTED_PROJECT_NAME%"

call :update_project_metadata
call :install_precommit
call :initialize_git_repo

call :log_success "Bootstrap completed!"
call :log_info "Next steps:"
echo   1. Update README.md
echo   2. Configure .github/CODEOWNERS  
echo   3. Start developing!

goto :eof

REM Start main execution
call :main
