# Example Usage Guide

## Quick Start

### 1. Template Instantiation

```bash
npx degit neomint-research/golden-repo my-new-project
cd my-new-project
```

### 2. Bootstrap Your Project

```bash
./bootstrap.sh    # Linux/macOS
.\bootstrap.ps1   # Windows
```

### 3. Customize

```bash
# Update project metadata
vim status.json agent.yml
# Configure requirements
vim .github/dependabot.yml .github/CODEOWNERS
```

## Features

### Security Workflows

- CodeQL static analysis, Trivy vulnerability scanning
- OSV dependency scanning, Secret detection
- Auto-merge for patch updates, manual review for major updates

### Code Quality

```bash
pre-commit install    # Install hooks
npm run format       # Format code
npm run test         # Run tests
```

## Project Structure Examples

```
Python:     src/my_project/, tests/, requirements.txt
JavaScript: src/, tests/, package.json
Full-Stack: frontend/, backend/, docker-compose.yml
```

## Configuration

### CODEOWNERS

```yaml
/src/auth/ @my-org/security-team /.github/workflows/ @my-org/devops-team
```

### Status.json

```json
{
  "project_name": "my-project",
  "version": "1.0.0",
  "environment": "production"
}
```

## Troubleshooting

```bash
# Update hooks
pre-commit autoupdate

# Debug mode
export DEBUG=1 && ./bootstrap.sh

# Check workflow logs
gh run list && gh run view <run-id>
```

## Best Practices

- Review security scan results
- Keep dependencies updated
- Run pre-commit hooks before pushing
- Use auto-merge for patch updates only

## Getting Help

- [Security documentation](../SECURITY.md)
- [Contributing guidelines](../CONTRIBUTING.md)
