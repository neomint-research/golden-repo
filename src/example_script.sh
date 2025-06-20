#!/bin/bash
# Example Script - Golden Repo Template
# Usage: ./src/example_script.sh [--verbose] [--dry-run] [--help]

set -euo pipefail

# Configuration
SCRIPT_NAME="$(basename "$0")"
VERBOSE=false
DRY_RUN=false

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

# Logging
log_error() { echo -e "${RED}[ERROR]${NC} $*" >&2; }
log_info() { echo -e "${BLUE}[INFO]${NC} $*"; }
log_success() { echo -e "${GREEN}[SUCCESS]${NC} $*"; }

# Help function
show_help() {
    cat << EOF
$SCRIPT_NAME - Example script for golden-repo template

USAGE: $SCRIPT_NAME [--verbose] [--dry-run] [--help]

OPTIONS:
    -v, --verbose    Enable verbose logging
    -n, --dry-run    Show what would be done
    -h, --help       Show this help

DESCRIPTION:
    Demonstrates shell script best practices with error handling,
    logging, and argument parsing.
EOF
}

# Main processing function
process_data() {
    local input_data="$1"
    log_info "Processing: $input_data"

    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would process: $input_data"
        return 0
    fi

    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    echo "{\"status\":\"success\",\"processed_at\":\"$timestamp\",\"input\":\"$input_data\"}"
    log_success "Processing completed"
}

# Argument parsing
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -v|--verbose) export VERBOSE=true; shift ;;
            -n|--dry-run) DRY_RUN=true; shift ;;
            -h|--help) show_help; exit 0 ;;
            *) log_error "Unknown option: $1"; exit 2 ;;
        esac
    done
}

# Main function
main() {
    log_info "Starting $SCRIPT_NAME"

    # Process example data
    if result=$(process_data "example-data"); then
        echo "$result"
        log_success "Completed successfully"
    else
        log_error "Processing failed"
        exit 1
    fi
}

# Entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    parse_arguments "$@"
    main
fi
