# Example Usage Guide

This guide demonstrates how to use the golden-repo template effectively for your projects.

## Quick Start

### 1. Template Instantiation

```bash
# Using degit (recommended)
npx degit neomint-research/golden-repo my-new-project
cd my-new-project

# Using git clone
git clone https://github.com/neomint-research/golden-repo.git my-new-project
cd my-new-project
rm -rf .git
git init
```

### 2. Bootstrap Your Project

```bash
# Linux/macOS
./bootstrap.sh

# Windows
.\bootstrap.ps1
```

### 3. Customize for Your Project

```bash
# Update project metadata
vim status.json
vim agent.yml

# Configure your specific requirements
vim .github/dependabot.yml
vim .github/CODEOWNERS
```

## Example Workflows

### Security-First Development

The template includes comprehensive security workflows:

```yaml
# .github/workflows/security-audit.yml
# Automatically runs:
# - CodeQL static analysis
# - Trivy vulnerability scanning
# - OSV dependency scanning
# - Secret detection with Gitleaks
# - Python dependency security checks
```

**Example security workflow trigger:**

```bash
# Push to main branch triggers security scan
git push origin main

# Manual security scan
gh workflow run security-audit.yml
```

### Automated Dependency Management

```yaml
# .github/dependabot.yml
# Automatically:
# - Updates dependencies daily
# - Creates PRs for security updates
# - Auto-merges patch updates
# - Requires manual review for major updates
```

**Example dependency update flow:**

1. Dependabot creates PR for security update
2. Auto-merge workflow validates security
3. If safe, automatically approves and merges
4. If issues found, blocks merge and notifies security team

### Code Quality Enforcement

```bash
# Pre-commit hooks automatically run:
pre-commit install

# Manual quality checks
npm run format        # Format with Prettier
npm run lint         # Lint code
npm run security     # Security scan
npm run test         # Run tests
```

## Example Project Structures

### Python Project

```
my-python-project/
├── src/
│   ├── my_project/
│   │   ├── __init__.py
│   │   ├── main.py
│   │   └── utils.py
│   └── example_tool.py          # Template example
├── tests/
│   ├── test_main.py
│   └── test_utils.py
├── requirements.txt
├── pyproject.toml
└── README.md
```

### JavaScript/Node.js Project

```
my-js-project/
├── src/
│   ├── index.js
│   ├── components/
│   └── utils/
├── tests/
│   ├── index.test.js
│   └── components/
├── package.json
├── package-lock.json
└── README.md
```

### Full-Stack Project

```
my-fullstack-project/
├── frontend/
│   ├── src/
│   ├── public/
│   └── package.json
├── backend/
│   ├── src/
│   ├── tests/
│   └── requirements.txt
├── docker-compose.yml
├── Dockerfile
└── README.md
```

## Configuration Examples

### Custom Security Rules

```yaml
# .github/CODEOWNERS
# Require security team review for sensitive files
/src/auth/ @my-org/security-team
/config/secrets/ @my-org/security-team
/.github/workflows/ @my-org/devops-team
```

### Environment-Specific Settings

```json
// status.json
{
  "project_name": "my-awesome-project",
  "version": "1.0.0",
  "environment": "production",
  "security_level": "high",
  "compliance_requirements": ["SOC2", "GDPR"]
}
```

### Custom Dependabot Configuration

```yaml
# .github/dependabot.yml
updates:
  - package-ecosystem: "npm"
    directory: "/frontend"
    schedule:
      interval: "daily"
    reviewers:
      - "my-org/frontend-team"
    
  - package-ecosystem: "pip"
    directory: "/backend"
    schedule:
      interval: "daily"
    reviewers:
      - "my-org/backend-team"
```

## Testing Examples

### Running Security Tests

```bash
# Full security audit
npm run security:audit

# Specific security checks
npm run security:secrets    # Check for secrets
npm run security:deps      # Check dependencies
npm run security:code      # Static analysis
```

### Integration Testing

```bash
# Test template instantiation
./test/test_template_structure.py

# Test all workflows
gh workflow run --ref main

# Test pre-commit hooks
pre-commit run --all-files
```

## Troubleshooting

### Common Issues

**Issue: Pre-commit hooks failing**
```bash
# Solution: Update hooks
pre-commit autoupdate
pre-commit install
```

**Issue: Security scan false positives**
```bash
# Solution: Configure exceptions
echo "rule-id" >> .security-exceptions
```

**Issue: Dependabot PRs not auto-merging**
```bash
# Solution: Check workflow permissions
# Ensure GITHUB_TOKEN has write permissions
```

### Debug Mode

```bash
# Enable verbose logging
export DEBUG=1
./bootstrap.sh

# Check workflow logs
gh run list
gh run view <run-id>
```

## Best Practices

### 1. Security First
- Always review security scan results
- Keep dependencies updated
- Use branch protection rules
- Enable required status checks

### 2. Code Quality
- Run pre-commit hooks before pushing
- Use consistent formatting
- Write comprehensive tests
- Document your code

### 3. Automation
- Let Dependabot handle routine updates
- Use auto-merge for patch updates only
- Review major version updates manually
- Monitor security alerts

### 4. Documentation
- Keep README.md updated
- Document configuration changes
- Maintain troubleshooting guides
- Update example usage

## Advanced Usage

### Custom Workflows

Create project-specific workflows in `.github/workflows/`:

```yaml
# .github/workflows/deploy.yml
name: Deploy to Production
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        run: ./scripts/deploy.sh
```

### Multi-Environment Setup

```bash
# Environment-specific configurations
config/
├── development.json
├── staging.json
└── production.json
```

### Custom Security Policies

```yaml
# .github/security-policy.yml
security:
  vulnerability_reporting:
    email: security@mycompany.com
  dependency_updates:
    auto_merge: patch
    require_review: minor,major
```

## Getting Help

- Check the [troubleshooting guide](../README.md#troubleshooting)
- Review [security documentation](../SECURITY.md)
- See [contributing guidelines](../CONTRIBUTING.md)
- Open an issue for template improvements
