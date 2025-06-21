# Extension Guide – NEOMINT-RESEARCH Project Structure

This document defines the allowed structure, file types, and naming patterns.

---

## Root Layout

```text
src/            → Tool code, modules, scripts
docs/           → Project documentation
test/           → Structural & unit tests
logs/           → Auto-fix output & traces
.github/        → CI + Security
.devcontainer/  → Codespaces-ready dev environment
```

## Accepted File Types

| Type           | Naming convention          |
| -------------- | -------------------------- |
| Scripts (bash) | `src/tool_name.sh`         |
| PowerShell     | `src/tool_name.ps1`        |
| Python         | `src/tool_name.py`         |
| Docs           | `docs/*.md`                |
| Status/Meta    | `agent.yml`, `status.json` |

## Directory Rules

- All files must follow `lower_case_with_underscores.ext`
- Avoid deep nesting; prefer flat structure
- Never create `.bak`, `.copy`, `.tmp` etc.

## Agent Instructions

- Use `extension-guide.md` to determine allowed paths
- Use `status.json` to detect task state
- Never write outside of `src/`, `docs/`, or `test/` unless explicitly allowed

---
