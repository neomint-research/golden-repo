# Code Quality Guidelines

This repository includes comprehensive code quality tools and standards.

## Static Code Review

The repository includes a comprehensive static code review system that checks for:

- **Code Quality**: Syntax, style, complexity, naming conventions
- **Security**: Hardcoded secrets, SQL injection, XSS vulnerabilities, path traversal
- **Best Practices**: SOLID principles, code smells, proper error handling
- **Dependencies**: Circular dependencies, unused imports, version constraints

## Running Quality Checks

```bash
# Run the comprehensive static code review
python -m pytest test/test_static_code_review.py -v

# Run style checks
python -m flake8 src/

# Run tests
python -m pytest test/ -v
```

## Quality Standards

- Maximum line length: 120 characters
- No critical security vulnerabilities in source code
- Proper error handling and logging
- Comprehensive test coverage
- Clear documentation and docstrings

## Automated Fixes

The static code review system can automatically fix:
- Trailing whitespace
- Import organization
- Basic style issues

Manual fixes are required for:
- Complex refactoring
- Security vulnerabilities
- Architecture improvements
