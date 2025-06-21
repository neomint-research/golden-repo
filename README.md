# NEOMINT-RESEARCH Project Template

[![Check Code & Format](https://github.com/neomint-research/golden-repo/actions/workflows/check-code.yml/badge.svg)](https://github.com/neomint-research/golden-repo/actions/workflows/check-code.yml)
[![Security Audit](https://github.com/neomint-research/golden-repo/actions/workflows/security-audit.yml/badge.svg)](https://github.com/neomint-research/golden-repo/actions/workflows/security-audit.yml)
[![Dependency Auto-Merge](https://github.com/neomint-research/golden-repo/actions/workflows/dependency-auto-merge.yml/badge.svg)](https://github.com/neomint-research/golden-repo/actions/workflows/dependency-auto-merge.yml)
[![License](https://img.shields.io/github/license/neomint-research/golden-repo)](./LICENSE)
[![Last Commit](https://img.shields.io/github/last-commit/neomint-research/golden-repo)](https://github.com/neomint-research/golden-repo/commits/main)

This is the official NEOMINT-RESEARCH template repository. It is designed for security-first,
agent-compatible, and highly reusable projects.

Supports:

- CLI tools, scripts (e.g. Python, PowerShell)
- Documentation and Markdown-based projects
- Agent-integrated workflows
- Research and hybrid setups

---

## Quickstart (One-Line Bootstrap)

```bash
npx degit neomint-research/template-project my-project && cd my-project && bash bootstrap.sh
```

> For Windows PowerShell:

```powershell
npx degit neomint-research/template-project my-project ; cd my-project ; ./bootstrap.ps1
```

---

## Security & Maintenance Features

| Feature             | Description                                 |
| ------------------- | ------------------------------------------- |
| Self-Healing CI     | Auto-corrects format/lint issues on commit  |
| Security Checks     | CodeQL, Trivy, OSV & Secretscanner          |
| Dependabot          | Daily update of dependencies and Actions    |
| CODEOWNERS          | Review enforcement for sensitive files      |
| Agent-Compatible    | Token-efficient, semantically guided layout |

---

## Project Structure Overview

```text
src/            → Code, scripts, modules
docs/           → Project documentation & lookups
.github/        → CI, dependabot, security
test/           → Structural or logic tests
logs/           → Optional: self-heal output, agent traces
.devcontainer/  → Codespaces-ready container setup
bootstrap.sh    → One-liner setup (Unix)
bootstrap.ps1   → One-liner setup (Windows)
agent.yml       → Context definition for coding agents
status.json     → Machine-readable project state
```

---

## Dev Commands

```bash
bash bootstrap.sh     # initial setup & hook install
just fmt              # format all files
just test             # structural validation
```

---

## Agent-First Architecture

This repository is agent-aware and designed for AI coding assistants.

### Agent Guidelines

**Role & Responsibility:**

- You are an assistant, not an author
- You act only where permitted (`src/`, `docs/`, `test/`)
- Do not create new top-level folders
- Do not modify root metadata files unless instructed

**Structure & Navigation:**

- `agent.yml` = roles, identity, behavior context
- `status.json` = current machine-understandable state
- `docs/extension-guide.md` = allowed file types, formats, placement
- `logs/*.md` = optional traces or decisions

**Architecture Principles:**

- Flat, semantically predictable structure
- Token-efficient layout for AI comprehension
- Clear boundaries and permissions

---

## License

See [`LICENSE`](./LICENSE)

## Security Contact

See [`SECURITY.md`](./SECURITY.md) or email **research@neomint.com**

## Learn More

- Structure: [`docs/extension-guide.md`](./docs/extension-guide.md)
- Contribution: [`CONTRIBUTING.md`](./CONTRIBUTING.md)
