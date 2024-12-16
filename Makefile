
.PHONY: setup-pre-commit
create-venv:
	@echo "Creating virtual environment if not exists..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		powershell -Command "if (-not (Test-Path .\.venv)) { python -m venv .\.venv }"; \
	else \
		test -d .venv || python3 -m venv .venv; \
	fi

setup-pre-commit:
	@echo "Installing pre-commit hooks..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		./.venv/Scripts/pre-commit install; \
	else \
	  	.venv/bin/pre-commit install; \
	fi
	@echo "Running pre-commit hooks to build environments so that first commit will be fast..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		./.venv/Scripts/pre-commit run --all-files || true; \
	else \
		.venv/bin/pre-commit run --all-files || true; \
	fi

.PHONY: pip
pip:
	@echo "Installing Python dependencies..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		./.venv/Scripts/python -m pip install -r requirements-dev.txt; \
	else \
		.venv/bin/python -m pip install -r requirements-dev.txt; \
	fi

.PHONY: ci
ci:
	@echo "Running pre-commit hooks..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		./.venv/Scripts/pre-commit run --all-files || true; \
	else \
		.venv/bin/pre-commit run --all-files || true; \
	fi
	@echo "Running tests..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		./.venv/Scripts/python -m pytest; \
	else \
		.venv/bin/python -m pytest; \
	fi

.PHONY: setup-all
setup-all: create-venv pip setup-pre-commit ci
	@echo "Python environment setup complete."