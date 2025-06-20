import os
import json
import yaml

REQUIRED = [
    "README.md", "LICENSE", "SECURITY.md", "CONTRIBUTING.md",
    "bootstrap.sh", "bootstrap.ps1",
    "agent.yml", "status.json",
    ".editorconfig", ".gitignore", ".gitattributes",
    ".pre-commit-config.yaml", ".prettierrc",
    ".github/workflows/check-code.yml",
    ".github/workflows/security-audit.yml",
    ".github/dependabot.yml",
    "docs/extension-guide.md",
    ".devcontainer/devcontainer.json"
]

def test_required_files():
    for path in REQUIRED:
        assert os.path.exists(path), f"Missing required file: {path}"

def test_readme_not_empty():
    with open("README.md", "r", encoding="utf-8") as f:
        assert len(f.read().strip()) > 30

def test_agent_yml_valid():
    with open("agent.yml", "r", encoding="utf-8") as f:
        yaml.safe_load(f)

def test_status_json_structure():
    with open("status.json", "r", encoding="utf-8") as f:
        d = json.load(f)
        assert "build" in d and "lint" in d