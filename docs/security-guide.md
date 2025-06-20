# Security Guide

## Security Features

### Automated Scanning
- **CodeQL**: Static analysis
- **Trivy**: Vulnerability scanning
- **OSV Scanner**: Dependency scanning
- **Gitleaks**: Secret detection
- **Bandit**: Python security linting

### Dependency Management
- **Dependabot**: Auto-updates
- **Auto-merge**: Patch updates only
- **Manual review**: Major updates

### Code Review
- **CODEOWNERS**: Security team review
- **Branch protection**: Required checks
- **Pre-commit hooks**: Security validation

## Configuration

### CODEOWNERS
```bash
/.github/workflows/ @org/security-team
/CODEOWNERS @org/security-team
```

### Branch Protection
- Require PR reviews (2 reviewers)
- Require status checks
- Restrict pushes to main

### Secret Management
```bash
# Use GitHub Secrets
${{ secrets.API_KEY }}

# Environment variables
export API_KEY="value"
```

## Best Practices

### Code Security
```python
# Use environment variables
api_key = os.getenv('API_KEY')  # Good
api_key = "secret"              # Bad
```

### Dependencies
```bash
npm audit fix    # Keep updated
pip-audit --fix  # Review changes
```

### CI/CD Security
```yaml
permissions:
  contents: read
  security-events: write
uses: actions/checkout@v4  # Pin versions
```

## Monitoring
- GitHub Security Tab: Dependabot/Code/Secret alerts
- Security reports: `security-summary.md`, `trivy-report.txt`

## Incident Response
1. Assess severity
2. Develop fix in private branch
3. Deploy and notify
4. Post-mortem

## Resources
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
