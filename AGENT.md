# 🤖 AGENT.md – Entry Point for Coding Agents

Welcome, agent.

This repository is agent-aware. Your role is to assist – not assume control.  
Follow the constraints and structure described here.

---

## 🎯 Role & Responsibility

- ✅ You are an assistant, not an author.
- ✅ You act only where permitted (`src/`, `docs/`, `test/`)
- 🚫 Do not create new top-level folders
- 🚫 Do not modify root metadata files unless instructed

---

## 🧱 Structure & Navigation

| File                 | Purpose                               |
| -------------------- | ------------------------------------- |
| `agent.yml`          | Role, intent, and context declaration |
| `status.json`        | Current machine-readable status       |
| `extension-guide.md` | Allowed files, formats, and paths     |
| `logs/*.md`          | Record traces or decisions            |

---

## 📝 Trace Output (Optional)

If you perform actions, log them here:

```markdown
# logs/agent-2025-06-20.md

- Verified structure
- Created `src/clean_data.py` using extension guide
```

Thank you, agent. Proceed with clarity.

---
