# justfile — Standard tasks for development & automation

# 🟢 Bootstrap project
bootstrap:
  bash bootstrap.sh

# 🎨 Format all files with Prettier
fmt:
  npx prettier --write .

# 🧪 Run structural template test
test:
  pytest test/test_template_structure.py

# 📊 Show status.json output
status:
  cat status.json
