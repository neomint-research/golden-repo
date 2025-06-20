#!/usr/bin/env bash
set -e

echo "🚀 Initializing NEOMINT-RESEARCH project..."

# Install pre-commit if missing
if ! command -v pre-commit &> /dev/null; then
  echo "🔧 Installing pre-commit..."
  pip install pre-commit
fi

# Activate git hooks
echo "🧰 Installing hooks..."
pre-commit install --install-hooks

# First run
echo "🎨 Running initial formatting..."
pre-commit run --all-files || true

echo "✅ Ready to go."