#!/usr/bin/env bash
# Golden Repo Template Bootstrap Script

set -euo pipefail

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }

# Project setup
detect_project_name() {
    local project_name
    project_name="$(basename "$(pwd)")"
    if [[ "$project_name" == "golden-repo" ]]; then
        read -r -p "Enter project name (default: my-project): " user_input
        project_name="${user_input:-my-project}"
    fi
    echo "$project_name"
}

update_project_metadata() {
    local project_name="$1"
    log_info "Updating metadata for: $project_name"

    # Update status.json
    if [[ -f "status.json" ]] && command -v python3 &> /dev/null; then
        python3 -c "
import json
with open('status.json', 'r+') as f:
    data = json.load(f)
    data['project_name'] = '$project_name'
    f.seek(0); json.dump(data, f, indent=2); f.truncate()
" 2>/dev/null || true
    fi
}

# Setup functions
install_precommit() {
    log_info "Setting up pre-commit..."

    if ! command -v pre-commit &> /dev/null; then
        if command -v pip3 &> /dev/null; then
            pip3 install pre-commit
        else
            log_error "pip3 not found. Please install pre-commit manually"
            exit 1
        fi
    fi

    pre-commit install --install-hooks
    log_success "Pre-commit hooks installed"
}

init_git_repo() {
    if [[ ! -d ".git" ]]; then
        log_info "Initializing git repository..."
        git init
        git add .
        git commit -m "Initial commit from golden-repo template"
        log_success "Git repository initialized"
    fi
}

# Main function
main() {
    echo "🚀 Golden Repo Template Bootstrap"
    echo "=================================="

    project_name=$(detect_project_name)
    log_info "Project: $project_name"

    update_project_metadata "$project_name"
    install_precommit
    init_git_repo

    log_success "Bootstrap completed!"
    log_info "Next steps:"
    echo "  1. Update README.md"
    echo "  2. Configure .github/CODEOWNERS"
    echo "  3. Start developing!"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
