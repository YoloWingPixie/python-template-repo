
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

.PHONY: choose-license
choose-license:
	@printf "\033[95m=======================\033[0m\n"
	@printf "\033[95mChoose a license type:\033[0m\n"
	@printf "\033[95m=======================\033[0m\n"
	@echo "1) GNU-GPL-3"; \
	echo "2) MIT"; \
	echo "3) MPL-2.0"; \
	echo "4) Unlicense"; \
	echo "5) Copyright (All rights reserved)"; \
	read -p "Enter your choice [1/2/3/4/5]: " choice; \
	if [ "$$choice" = "1" ]; then \
		cp licenses/GNU-GPL-3 LICENSE; \
		echo "GNU-GPL-3 License copied to LICENSE file."; \
	elif [ "$$choice" = "2" ]; then \
		current_year=$$(date +%Y); \
		read -p "Enter Name: " name; \
		sed "s/{YEAR}/$$current_year/g; s/{NAME}/$$name/g" licenses/MIT > LICENSE; \
		echo "MIT License customized and copied to LICENSE file."; \
	elif [ "$$choice" = "3" ]; then \
		cp licenses/MPL-2.0 LICENSE; \
		echo "MPL-2.0 License copied to LICENSE file."; \
	elif [ "$$choice" = "4" ]; then \
		cp licenses/Unlicense LICENSE; \
		echo "Unlicense copied to LICENSE file."; \
	elif [ "$$choice" = "5" ]; then \
		current_year=$$(date +%Y); \
		read -p "Enter Name: " name; \
		echo "LICENSE" > LICENSE; \
		echo "Copyright (c) $$current_year, $$name" >> LICENSE; \
		echo "" >> LICENSE; \
		echo "All rights reserved." >> LICENSE; \
		echo "Simple copyright LICENSE file created."; \
	else \
		echo "Invalid choice. Exiting."; \
		exit 1; \
	fi; \
	echo ""; \
	echo "License file created successfully, we don't need the /license directory anymore and it can be removed."; \
	if [ "$$OSTYPE" = "cygwin" ] || [ "$$OSTYPE" = "msys" ] || [ "$$OS" = "Windows_NT" ]; then \
		echo -e "Run '\033[32mpowershell -Command \"Remove-Item -Recurse -Force .\\licenses\"\033[0m' to delete the licenses folder."; \
	else \
		echo -e "Run '\033[32mrm -rf licenses\033[0m' to delete the licenses folder."; \
	fi


.PHONY: setup-all
setup-all: create-venv pip setup-pre-commit ci choose-license
	@echo "Python environment setup complete."
	@echo -e "Run '\033[32mmake reset-sphinx\033[0m' now to reset Sphinx documentation."
