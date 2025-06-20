#!/bin/bash
# Example Script - Demonstrates proper shell script structure for the golden-repo template
#
# This script serves as an example of how to structure shell scripts in this template.
# It follows best practices for:
# - Error handling and validation
# - Logging and output formatting
# - Configuration management
# - Documentation and help text
#
# Usage:
#   ./src/example_script.sh --config config.json --verbose
#   ./src/example_script.sh --help
#
# Author: Golden Repo Template
# Version: 1.0.0

set -euo pipefail  # Exit on error, undefined vars, pipe failures

# Script configuration
SCRIPT_NAME="$(basename "$0")"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Default configuration
DEFAULT_CONFIG_FILE="$PROJECT_ROOT/config/default.json"
LOG_LEVEL="INFO"
VERBOSE=false
DRY_RUN=false

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

log_debug() {
    if [[ "$VERBOSE" == "true" ]]; then
        echo -e "[DEBUG] $*" >&2
    fi
}

# Help function
show_help() {
    cat << EOF
$SCRIPT_NAME - Example script demonstrating proper shell script structure

USAGE:
    $SCRIPT_NAME [OPTIONS]

OPTIONS:
    -c, --config FILE    Configuration file path (default: $DEFAULT_CONFIG_FILE)
    -v, --verbose        Enable verbose logging
    -n, --dry-run        Show what would be done without executing
    -h, --help           Show this help message
    --version            Show version information

EXAMPLES:
    $SCRIPT_NAME --config custom-config.json --verbose
    $SCRIPT_NAME --dry-run
    $SCRIPT_NAME --help

DESCRIPTION:
    This script demonstrates proper shell script structure and best practices
    for the golden-repo template. It includes:
    
    - Proper error handling with set -euo pipefail
    - Structured logging with different levels
    - Configuration file support
    - Command-line argument parsing
    - Dry-run mode for safe testing
    - Comprehensive help documentation

EXIT CODES:
    0    Success
    1    General error
    2    Invalid arguments
    3    Configuration error
    4    Execution error

EOF
}

# Version function
show_version() {
    echo "$SCRIPT_NAME version 1.0.0"
    echo "Part of the golden-repo template"
}

# Configuration loading
load_config() {
    local config_file="$1"
    
    log_debug "Loading configuration from: $config_file"
    
    if [[ ! -f "$config_file" ]]; then
        log_warn "Configuration file not found: $config_file"
        log_info "Using default configuration"
        return 0
    fi
    
    # Validate JSON format
    if ! python3 -m json.tool "$config_file" > /dev/null 2>&1; then
        log_error "Invalid JSON format in configuration file: $config_file"
        return 3
    fi
    
    log_success "Configuration loaded successfully"
    return 0
}

# Input validation
validate_environment() {
    log_debug "Validating environment..."
    
    # Check required commands
    local required_commands=("python3" "jq" "curl")
    for cmd in "${required_commands[@]}"; do
        if ! command -v "$cmd" &> /dev/null; then
            log_error "Required command not found: $cmd"
            return 4
        fi
    done
    
    # Check project structure
    local required_dirs=("src" "test" ".github")
    for dir in "${required_dirs[@]}"; do
        if [[ ! -d "$PROJECT_ROOT/$dir" ]]; then
            log_warn "Expected directory not found: $dir"
        fi
    done
    
    log_success "Environment validation completed"
    return 0
}

# Main processing function
process_data() {
    local input_data="$1"
    
    log_info "Processing data..."
    log_debug "Input data: $input_data"
    
    if [[ "$DRY_RUN" == "true" ]]; then
        log_info "[DRY RUN] Would process data: $input_data"
        return 0
    fi
    
    # Example processing logic
    local timestamp
    timestamp=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
    
    local result
    result=$(cat << EOF
{
    "status": "success",
    "processed_at": "$timestamp",
    "input": "$input_data",
    "script": "$SCRIPT_NAME",
    "project_root": "$PROJECT_ROOT"
}
EOF
)
    
    log_success "Data processing completed"
    echo "$result"
    return 0
}

# Cleanup function
cleanup() {
    local exit_code=$?
    log_debug "Cleanup function called with exit code: $exit_code"
    
    # Perform any necessary cleanup here
    # Remove temporary files, close connections, etc.
    
    if [[ $exit_code -eq 0 ]]; then
        log_success "Script completed successfully"
    else
        log_error "Script failed with exit code: $exit_code"
    fi
    
    exit $exit_code
}

# Set up signal handlers
trap cleanup EXIT
trap 'log_error "Script interrupted"; exit 130' INT TERM

# Argument parsing
parse_arguments() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -c|--config)
                CONFIG_FILE="$2"
                shift 2
                ;;
            -v|--verbose)
                VERBOSE=true
                LOG_LEVEL="DEBUG"
                shift
                ;;
            -n|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            --version)
                show_version
                exit 0
                ;;
            *)
                log_error "Unknown option: $1"
                log_info "Use --help for usage information"
                exit 2
                ;;
        esac
    done
}

# Main function
main() {
    local config_file="${CONFIG_FILE:-$DEFAULT_CONFIG_FILE}"
    
    log_info "Starting $SCRIPT_NAME"
    log_debug "Project root: $PROJECT_ROOT"
    log_debug "Configuration file: $config_file"
    log_debug "Verbose mode: $VERBOSE"
    log_debug "Dry run mode: $DRY_RUN"
    
    # Load configuration
    if ! load_config "$config_file"; then
        log_error "Failed to load configuration"
        exit 3
    fi
    
    # Validate environment
    if ! validate_environment; then
        log_error "Environment validation failed"
        exit 4
    fi
    
    # Process example data
    local example_data="example-input-data"
    local result
    if result=$(process_data "$example_data"); then
        log_info "Processing result:"
        echo "$result" | python3 -m json.tool
    else
        log_error "Data processing failed"
        exit 4
    fi
    
    log_success "All operations completed successfully"
}

# Script entry point
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    # Parse command line arguments
    parse_arguments "$@"
    
    # Run main function
    main
fi
