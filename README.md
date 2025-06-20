# 🛡️ NEOMINT-RESEARCH Project Template

This is the official NEOMINT-RESEARCH template repository. It is designed for security-first, agent-compatible, and highly reusable projects.

Supports:
- 🛠️ CLI tools, scripts (e.g. Python, PowerShell)
- 📄 Documentation and Markdown-based projects
- 🤖 Agent-integrated workflows
- 📊 Research and hybrid setups

---

## 🚀 Quickstart (One-Line Bootstrap)
```bash
npx degit neomint-research/template-project my-project && cd my-project && bash bootstrap.sh
```
> For Windows PowerShell:
```powershell
npx degit neomint-research/template-project my-project ; cd my-project ; ./bootstrap.ps1
```

---

## 🔐 Security & Maintenance Features

| Feature               | Description |
|-----------------------|-------------|
| ✅ Self-Healing CI | Auto-corrects format/lint issues on commit |
| ✅ Security Checks  | CodeQL, Trivy, OSV & Secretscanner |
| ✅ Dependabot       | Daily update of dependencies and Actions |
| ✅ CODEOWNERS       | Review enforcement for sensitive files |
| ✅ Agent-Compatible | Token-efficient, semantically guided layout |

---

## 📆 Project Structure Overview
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

## 💼 Dev Commands
```bash
bash bootstrap.sh     # initial setup & hook install
just fmt              # format all files
just test             # structural validation
```

---

## 🤖 Agent-First Architecture

- Flat, semantically predictable structure
- `agent.yml` = roles, identity, behavior
- `status.json` = current machine-understandable state
- `extension-guide.md` = all allowed file types, formats, placement

---

## 📄 License
See [`LICENSE`](./LICENSE)

## 📨 Security Contact
See [`SECURITY.md`](./SECURITY.md) or email **research@neomint.com**

## 🧠 Learn More
- Structure: [`docs/extension-guide.md`](./docs/extension-guide.md)
- Contribution: [`CONTRIBUTING.md`](./CONTRIBUTING.md)