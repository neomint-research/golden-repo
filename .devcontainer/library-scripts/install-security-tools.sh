#!/bin/bash
# Install security tools for development container

set -e

echo "Installing security tools..."

# Install detect-secrets for secret scanning
pip install detect-secrets

# Install bandit for Python security analysis
pip install bandit

# Install safety for Python dependency vulnerability checking
pip install safety

echo "Security tools installed successfully!"
