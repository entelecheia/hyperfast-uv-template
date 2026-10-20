SHELL := bash
.DEFAULT_GOAL := help

.PHONY: install
install: ## Create the virtual environment with all dependency groups (writes uv.lock if missing)
	@uv sync

.PHONY: lint
lint: ## Lock consistency, ruff, and mypy
	@uv lock --locked
	@uv run ruff check .
	@uv run ruff format --check .
	@uv run mypy

.PHONY: test
test: ## Tests with coverage
	@uv run pytest --cov --cov-report=term-missing

.PHONY: verify
verify: lint test ## The one gate: run before reporting any change complete

.PHONY: build
build: ## Build sdist and wheel into dist/
	@uv build

.PHONY: docs-test
docs-test: ## Build the docs strictly
	@uv run mkdocs build --strict

.PHONY: docs
docs: ## Serve the docs locally
	@uv run mkdocs serve

.PHONY: template-update
template-update: ## Update the project from the template, then review the diff
	@uvx copier@9.19.1 update -a .copier-config.yaml --trust

.PHONY: render-test
render-test: ## Render the template in each variant and run the generated gate
	@bash scripts/render-test.sh

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'
