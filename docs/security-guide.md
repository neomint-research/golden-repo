# Security Guide

This guide explains the security features and best practices included in the golden-repo template.

## Security Features Overview

### 1. Automated Security Scanning

The template includes comprehensive security scanning:

- **CodeQL**: Static analysis for security vulnerabilities
- **Trivy**: Container and filesystem vulnerability scanning
- **OSV Scanner**: Open source vulnerability database scanning
- **Gitleaks**: Secret detection in git history
- **Bandit**: Python security linting
- **Safety**: Python dependency vulnerability checking

### 2. Dependency Security Management

- **Dependabot**: Automated dependency updates
- **Auto-merge**: Secure automatic merging of patch updates
- **Security-first**: Priority handling of security updates
- **Review requirements**: Manual review for major updates

### 3. Code Review Security

- **CODEOWNERS**: Mandatory security team review for sensitive files
- **Branch protection**: Required status checks and reviews
- **Pre-commit hooks**: Security checks before code commits

## Security Workflow Details

### Daily Security Scans

```yaml
# Runs daily at 2 AM UTC
schedule:
  - cron: '0 2 * * *'
```

**What gets scanned:**
- All source code for vulnerabilities
- Dependencies for known security issues
- Git history for accidentally committed secrets
- Container images for security vulnerabilities

### Security Alert Response

When security issues are detected:

1. **Critical Issues**: Immediate notification to security team
2. **High Issues**: Daily summary report
3. **Medium/Low Issues**: Weekly summary report

### Dependency Update Security

```yaml
# Auto-merge criteria:
- Security updates: Always auto-merge after validation
- Patch updates: Auto-merge if tests pass
- Minor updates: Require team review
- Major updates: Require security team review
```

## Security Configuration

### CODEOWNERS Security Rules

```bash
# Security-sensitive files require security team review
/.github/workflows/ @org/security-team @org/devops-team
/CODEOWNERS @org/security-team @org/maintainers
/.github/dependabot.yml @org/security-team
/security/ @org/security-team
```

### Branch Protection Rules

Recommended settings:
- Require pull request reviews (2 reviewers)
- Require status checks to pass
- Require branches to be up to date
- Restrict pushes to main branch
- Require signed commits

### Secret Management

**Never commit secrets!** Use these alternatives:

```bash
# GitHub Secrets (recommended)
${{ secrets.API_KEY }}

# Environment variables
export API_KEY="your-secret-here"

# External secret management
# - AWS Secrets Manager
# - Azure Key Vault
# - HashiCorp Vault
```

## Security Best Practices

### 1. Code Security

```python
# Good: Use environment variables
import os
api_key = os.getenv('API_KEY')

# Bad: Hardcoded secrets
api_key = "sk-1234567890abcdef"  # Never do this!
```

### 2. Dependency Security

```bash
# Keep dependencies updated
npm audit fix
pip-audit --fix

# Review dependency changes
git diff package-lock.json
git diff requirements.txt
```

### 3. Container Security

```dockerfile
# Use specific versions, not 'latest'
FROM python:3.11.8-slim

# Run as non-root user
RUN adduser --disabled-password --gecos '' appuser
USER appuser

# Scan for vulnerabilities
RUN trivy fs .
```

### 4. CI/CD Security

```yaml
# Use minimal permissions
permissions:
  contents: read
  security-events: write

# Pin action versions
uses: actions/checkout@v4  # Not @main

# Validate inputs
run: |
  if [[ ! "$INPUT" =~ ^[a-zA-Z0-9_-]+$ ]]; then
    echo "Invalid input"
    exit 1
  fi
```

## Security Monitoring

### GitHub Security Tab

Monitor security alerts in your repository's Security tab:
- **Dependabot alerts**: Vulnerable dependencies
- **Code scanning alerts**: Security vulnerabilities in code
- **Secret scanning alerts**: Accidentally committed secrets

### Security Reports

The template generates security reports:

```bash
# View latest security summary
cat security-summary.md

# Check Trivy report
cat trivy-report.txt

# Review Bandit findings
cat bandit-report.json
```

### Metrics and KPIs

Track these security metrics:
- Time to fix critical vulnerabilities
- Number of security alerts resolved
- Dependency update frequency
- Security scan coverage

## Incident Response

### Security Vulnerability Discovered

1. **Assess severity** using CVSS scoring
2. **Create security advisory** if needed
3. **Develop fix** in private branch
4. **Test fix** thoroughly
5. **Deploy fix** and notify users
6. **Post-mortem** to prevent recurrence

### Secret Exposure

If secrets are accidentally committed:

1. **Immediately revoke** the exposed secret
2. **Generate new secret** with different value
3. **Update all systems** using the secret
4. **Remove secret from git history**:
   ```bash
   git filter-branch --force --index-filter \
     'git rm --cached --ignore-unmatch path/to/secret' \
     --prune-empty --tag-name-filter cat -- --all
   ```

### Security Audit Findings

When security audits identify issues:

1. **Prioritize by risk** (Critical > High > Medium > Low)
2. **Create tracking issues** for each finding
3. **Assign owners** and due dates
4. **Implement fixes** in priority order
5. **Verify fixes** with follow-up scans
6. **Document lessons learned**

## Compliance Considerations

### SOC 2 Compliance

The template supports SOC 2 requirements:
- **Security**: Automated security scanning
- **Availability**: Monitoring and alerting
- **Processing Integrity**: Code review requirements
- **Confidentiality**: Secret management
- **Privacy**: Data handling guidelines

### GDPR Compliance

For GDPR compliance:
- Document data processing activities
- Implement data retention policies
- Ensure data portability features
- Maintain audit logs
- Conduct privacy impact assessments

## Security Tools Integration

### IDE Security Extensions

Recommended security extensions:
- **VS Code**: GitLens, Security Code Scan
- **IntelliJ**: SonarLint, Security Code Scan
- **Vim**: ALE with security linters

### Local Security Testing

```bash
# Install security tools locally
pip install bandit safety
npm install -g audit-ci

# Run security checks
bandit -r src/
safety check
audit-ci --moderate
```

### Security Training

Regular security training topics:
- Secure coding practices
- Threat modeling
- Incident response procedures
- Compliance requirements
- Tool usage and best practices

## Getting Security Help

### Internal Resources
- Security team contact: security@company.com
- Security documentation: /docs/security/
- Incident response: /docs/incident-response/

### External Resources
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [NIST Cybersecurity Framework](https://www.nist.gov/cyberframework)
- [GitHub Security Best Practices](https://docs.github.com/en/code-security)
- [SANS Secure Coding Practices](https://www.sans.org/white-papers/2172/)

## Security Checklist

Before deploying to production:

- [ ] All security scans pass
- [ ] No hardcoded secrets in code
- [ ] Dependencies are up to date
- [ ] Security team has reviewed changes
- [ ] Branch protection rules are enabled
- [ ] Monitoring and alerting configured
- [ ] Incident response plan updated
- [ ] Security documentation current
