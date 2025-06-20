#!/usr/bin/env bash
# Golden Repo Template Bootstrap Script
# Initializes a new project from the golden-repo template

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Script configuration
SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_error() {
    echo -e "${RED}[ERROR]${NC} $*" >&2
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $*" >&2
}

log_info() {
    echo -e "${BLUE}[INFO]${NC} $*"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $*"
}

# Error handling
cleanup() {
    local exit_code=$?
    if [[ $exit_code -ne 0 ]]; then
        log_error "Bootstrap failed with exit code: $exit_code"
        log_info "Please check the error messages above and try again"
    fi
    exit $exit_code
}

trap cleanup EXIT

# Project name detection and templating
detect_project_name() {
    local project_name

    # Try to get project name from directory
    project_name="$(basename "$SCRIPT_DIR")"

    # If it's still "golden-repo", ask user
    if [[ "$project_name" == "golden-repo" ]]; then
        read -p "Enter your project name (or press Enter for 'my-project'): " user_input
        project_name="${user_input:-my-project}"
    fi

    echo "$project_name"
}

# Update project metadata
update_project_metadata() {
    local project_name="$1"

    log_info "Updating project metadata for: $project_name"

    # Update status.json if it exists
    if [[ -f "status.json" ]]; then
        if command -v python3 &> /dev/null; then
            python3 -c "
import json
try:
    with open('status.json', 'r') as f:
        data = json.load(f)
    data['project_name'] = '$project_name'
    data['lastUpdate'] = '$(date -u +%Y-%m-%d)'
    with open('status.json', 'w') as f:
        json.dump(data, f, indent=2)
    print('Updated status.json')
except Exception as e:
    print(f'Warning: Could not update status.json: {e}')
"
        fi
    fi

    # Update agent.yml if it exists
    if [[ -f "agent.yml" ]]; then
        sed -i.bak "s/identity: .*/identity: $project_name/" agent.yml 2>/dev/null || true
        rm -f agent.yml.bak 2>/dev/null || true
    fi
}

# Check prerequisites
check_prerequisites() {
    log_info "Checking prerequisites..."

    local missing_tools=()

    # Check for required tools
    if ! command -v git &> /dev/null; then
        missing_tools+=("git")
    fi

    if ! command -v python3 &> /dev/null && ! command -v python &> /dev/null; then
        missing_tools+=("python3")
    fi

    if [[ ${#missing_tools[@]} -gt 0 ]]; then
        log_error "Missing required tools: ${missing_tools[*]}"
        log_info "Please install the missing tools and try again"
        exit 1
    fi

    log_success "All prerequisites satisfied"
}

# Install pre-commit
install_precommit() {
    log_info "Setting up pre-commit hooks..."

    if ! command -v pre-commit &> /dev/null; then
        log_info "Installing pre-commit..."

        # Try pip3 first, then pip
        if command -v pip3 &> /dev/null; then
            pip3 install pre-commit
        elif command -v pip &> /dev/null; then
            pip install pre-commit
        else
            log_error "Could not find pip or pip3 to install pre-commit"
            log_info "Please install pre-commit manually: pip install pre-commit"
            exit 1
        fi
    else
        log_info "pre-commit already installed"
    fi

    # Install hooks
    if ! pre-commit install --install-hooks; then
        log_error "Failed to install pre-commit hooks"
        exit 1
    fi

    log_success "Pre-commit hooks installed successfully"
}

# Run initial formatting
run_initial_formatting() {
    log_info "Running initial code formatting..."

    # Run pre-commit on all files
    if pre-commit run --all-files; then
        log_success "All pre-commit checks passed"
    else
        log_warn "Some pre-commit checks failed, but this is normal for initial setup"
        log_info "Files have been automatically formatted where possible"
    fi
}

# Initialize git repository if needed
init_git_repo() {
    if [[ ! -d ".git" ]]; then
        log_info "Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit from golden-repo template"
        log_success "Git repository initialized"
    else
        log_info "Git repository already exists"
    fi
}

# Main bootstrap function
main() {
    local project_name

    echo "========================================"
    echo "🚀 Golden Repo Template Bootstrap"
    echo "========================================"
    echo

    # Detect project name
    project_name=$(detect_project_name)
    log_info "Project name: $project_name"
    echo

    # Run bootstrap steps
    check_prerequisites
    update_project_metadata "$project_name"
    install_precommit
    run_initial_formatting
    init_git_repo

    echo
    echo "========================================"
    log_success "Bootstrap completed successfully!"
    echo "========================================"
    echo
    log_info "Your project '$project_name' is ready for development"
    log_info "Next steps:"
    echo "  1. Review and customize .github/CODEOWNERS"
    echo "  2. Update README.md with your project details"
    echo "  3. Configure .github/dependabot.yml for your needs"
    echo "  4. Start developing your amazing project!"
    echo
    log_info "For more information, see docs/example-usage.md"
}

# Run main function if script is executed directly
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi