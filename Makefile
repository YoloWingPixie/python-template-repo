
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

.PHONY: reset-sphinx
reset-sphinx:
	@echo "Resetting Sphinx documentation..."
	@echo "Clearing contents of /docs directory..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		powershell -Command "Get-ChildItem -Path docs -Recurse | Remove-Item -Recurse -Force | Out-Null"; \
	else \
		rm -rf docs/*; \
	fi
	@echo "Re-running sphinx-quickstart to set up /docs..."
	@if [ "$(OS)" = "Windows_NT" ]; then \
		powershell -Command "sphinx-quickstart docs"; \
	else \
		sphinx-quickstart docs; \
	fi
	@echo "Sphinx documentation reset complete."

.PHONY: setup-all
setup-all: create-venv pip setup-pre-commit ci
	@echo "Python environment setup complete."
	@echo -e "Run '\033[32mmake reset-sphinx\033[0m' now to reset Sphinx documentation."
