# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

### Development Setup
```bash
make install        # Install virtual environment with uv and pre-commit hooks
uv sync            # Sync dependencies
uv run pre-commit install  # Install pre-commit hooks manually
```

### Code Quality
```bash
make check         # Run all code quality checks (lint, type check, dependency check)
uv run ruff check src/  # Run linter only
uv run ruff format src/  # Format code with ruff
uv run mypy src/   # Run type checking only
uv run deptry .    # Check for obsolete dependencies
uv run pre-commit run -a  # Run all pre-commit hooks
```

### Testing
```bash
make test          # Run all tests with coverage (outputs to tests/pytest-coverage.txt)
uv run pytest      # Run tests without coverage
uv run pytest tests/hyperfastuv/test_cli.py  # Run specific test file
uv run pytest -k "test_function_name"  # Run specific test by name
uv run pytest --cov --cov-report=xml  # Generate coverage.xml for CI
uv run tox-uv      # Test across Python 3.9-3.13
```

### Building & Publishing
```bash
make build         # Build wheel file using hatchling
make publish       # Publish to PyPI (requires credentials)
uvx twine upload dist/*  # Manual upload to PyPI
```

### Documentation
```bash
make docs          # Build and serve documentation locally (http://127.0.0.1:8000)
make docs-test     # Test documentation build without serving
uv run mkdocs build  # Build static docs to site/
```

### Template Management (Copier)
```bash
make init-project  # Initialize new project from this template
make reinit-project  # Update existing project from template
copier copy --trust --answers-file .copier-config.yaml gh:entelecheia/hyperfast-uv-template .
```

## Architecture

This is a Copier-based Python package template designed for rapid project bootstrapping with modern tooling.

### Project Purpose
This repository serves as a **template generator** for Python projects. It uses Copier to create customized project scaffolds based on user inputs. The generated projects include pre-configured development tools, CI/CD pipelines, and documentation.

### Package Structure
- **src/hyperfastuv/**: Template demonstration package
  - `__init__.py`: Package initialization with `get_version()` function
  - `__cli__.py`: Click-based CLI with greeting functionality
  - `_version.py`: Semantic versioning managed by python-semantic-release
  - `conf/about/`: YAML configuration files for package metadata

### Template System
- **copier.yaml**: Template configuration with questions for project customization
- **.copier-template/**: Template source files (Jinja2 templates)
- **.copier-config.yaml**: Saved answers for template regeneration
- Supports nested templates via `code_template_source` parameter

### Development Stack
- **Package Manager**: uv (high-performance Python package installer)
- **Build System**: Hatchling with wheel distribution
- **Testing**: pytest with coverage reporting, tox for multi-version testing
- **Linting/Formatting**: Ruff (replaces black, isort, flake8)
- **Type Checking**: mypy with strict configuration
- **Pre-commit**: Automated checks for YAML, TOML, merge conflicts
- **Documentation**: MkDocs Material with mkdocstrings for API docs
- **CI/CD**: GitHub Actions workflows for testing, releasing, and docs deployment

### Key Configuration Files
- `pyproject.toml`: Unified configuration for all tools (PEP 621 compliant)
- `uv.lock`: Reproducible dependency resolution
- `.python-version`: Python 3.11 as default
- `tox.ini`: Test matrix for Python 3.9-3.13
- `.pre-commit-config.yaml`: Git hooks for code quality

### CI/CD Workflows
- **lint_and_test.yaml**: Runs on push to main, executes checks and tests
- **release.yaml**: Semantic release on main branch merges
- **deploy-docs.yaml**: Publishes documentation to GitHub Pages

### Release Process
Uses python-semantic-release with Angular commit convention:
- `feat:` triggers minor version bump
- `fix:` or `perf:` triggers patch version bump
- `BREAKING CHANGE:` triggers major version bump
- Automatically updates version in `pyproject.toml` and `_version.py`
- Creates GitHub releases with changelog