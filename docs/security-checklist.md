# Security Checklist

Use this checklist when setting up a new project from the golden-repo template.

## 🔧 Initial Setup

- [ ] **Repository Settings**

  - [ ] Enable "Restrict pushes that create files larger than 100 MB"
  - [ ] Enable "Restrict pushes that create files larger than 5 GB"
  - [ ] Disable "Allow merge commits" (optional, prefer squash/rebase)
  - [ ] Enable "Automatically delete head branches"

- [ ] **Branch Protection**

  - [ ] Protect `main` branch
  - [ ] Require pull request reviews (minimum 1)
  - [ ] Require status checks to pass
  - [ ] Require branches to be up to date
  - [ ] Restrict pushes to matching branches

- [ ] **Security & Analysis**
  - [ ] Enable Dependabot alerts
  - [ ] Enable Dependabot security updates
  - [ ] Enable CodeQL analysis
  - [ ] Enable Secret scanning
  - [ ] Enable Push protection for secrets

## 🔐 Secrets Management

- [ ] **Environment Variables**

  - [ ] Review all hardcoded values
  - [ ] Move sensitive data to GitHub Secrets
  - [ ] Use environment-specific secrets (dev/staging/prod)
  - [ ] Document required secrets in README

- [ ] **API Keys & Tokens**
  - [ ] Rotate any example/template keys
  - [ ] Use least-privilege access principles
  - [ ] Set expiration dates where possible
  - [ ] Monitor usage and access logs

## 📦 Dependencies

- [ ] **Package Management**

  - [ ] Review all dependencies in package.json/requirements.txt
  - [ ] Remove unused dependencies
  - [ ] Pin versions for production dependencies
  - [ ] Use lock files (package-lock.json, requirements.txt with versions)

- [ ] **Vulnerability Scanning**
  - [ ] Run `npm audit` or `pip-audit`
  - [ ] Review Dependabot alerts
  - [ ] Set up automated dependency updates
  - [ ] Configure vulnerability thresholds

## 🔍 Code Security

- [ ] **Static Analysis**

  - [ ] Configure CodeQL for your language
  - [ ] Set up additional linters (ESLint, Bandit, etc.)
  - [ ] Review and customize security rules
  - [ ] Fix all high/critical findings

- [ ] **Secret Detection**
  - [ ] Update `.secrets.baseline` if needed
  - [ ] Run `detect-secrets scan` locally
  - [ ] Configure pre-commit hooks
  - [ ] Train team on secret handling

## 🚀 CI/CD Security

- [ ] **Workflow Permissions**

  - [ ] Use minimal required permissions
  - [ ] Avoid `write-all` permissions
  - [ ] Use environment-specific approvals
  - [ ] Audit workflow runs regularly

- [ ] **Third-party Actions**
  - [ ] Pin action versions to specific commits
  - [ ] Review action permissions and access
  - [ ] Use official/verified actions when possible
  - [ ] Monitor for action updates

## 🏢 Team & Access

- [ ] **Repository Access**

  - [ ] Review collaborator permissions
  - [ ] Use teams instead of individual access
  - [ ] Implement least-privilege access
  - [ ] Regular access reviews

- [ ] **Code Reviews**
  - [ ] Require security-focused reviews
  - [ ] Train reviewers on security patterns
  - [ ] Use security-focused review checklists
  - [ ] Document security decisions

## 📊 Monitoring & Incident Response

- [ ] **Security Monitoring**

  - [ ] Set up security alert notifications
  - [ ] Monitor dependency vulnerabilities
  - [ ] Track security metrics
  - [ ] Regular security assessments

- [ ] **Incident Response**
  - [ ] Document security contact information
  - [ ] Create incident response procedures
  - [ ] Test incident response plan
  - [ ] Maintain security documentation

## 🔄 Regular Maintenance

- [ ] **Monthly Tasks**

  - [ ] Review security alerts
  - [ ] Update dependencies
  - [ ] Audit access permissions
  - [ ] Check for new security features

- [ ] **Quarterly Tasks**
  - [ ] Security architecture review
  - [ ] Penetration testing (if applicable)
  - [ ] Security training updates
  - [ ] Policy and procedure updates

## 📚 Documentation

- [ ] **Security Documentation**

  - [ ] Update SECURITY.md with project-specific info
  - [ ] Document security architecture
  - [ ] Create security runbooks
  - [ ] Maintain security changelog

- [ ] **Team Training**
  - [ ] Security awareness training
  - [ ] Secure coding practices
  - [ ] Incident response procedures
  - [ ] Tool-specific training

---

## 🆘 Need Help?

- **Security Questions**: research@neomint.com
- **GitHub Security**: https://docs.github.com/en/code-security
- **OWASP Guidelines**: https://owasp.org/
- **Security Team**: @neomint-research/security-team
