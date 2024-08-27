# Globals
PYTHON_VERSION = 3.10


# A function to check if a dependency is installed. If not, ask the user for permission to install it.
define dependency_check
	echo "🤔 Checking if $(1) is installed on your system..."
	if $(1) --version &> /dev/null; then \
		echo "🥳 $(1) is already installed on your system."; \
	else \
		if [ "$(shell uname)" != "Darwin" ]; then \
			echo "$(1) isn't installed on your system. Please install it and retry this command."; \
			exit 1; \
		else \
			echo "❓  $(1) isn't installed on your system. Can we install it? [Y/n]"; \
			read -r line; \
			if [ $$line = "Y" ] || [ $$line = "y" ]; then \
			   echo "Installing $(1)..."; \
			   HOMEBREW_NO_AUTO_UPDATE=1 brew install $(1) -q; \
			else \
			   echo "Stopping the installation process and project setup"; \
			   exit 1; \
			fi; \
		fi; \
	fi
endef

.PHONY: pre-commit-install
pre-commit-install:
	@$(call dependency_check,pre-commit)

.PHONY: pyenv-install
pyenv-install:
	@$(call dependency_check,pyenv)

.PHONY: poetry-install
poetry-install:
	@$(call dependency_check,poetry)

.PHONY: env-setup # Phony Target
env-setup: # Create virtual environment using pyenv and poetry
	@echo "🚀 Creating virtual environment using pyenv and poetry"
	@if ! pyenv versions --bare | grep -q "$(PYTHON_VERSION)"; then \
		pyenv install $(PYTHON_VERSION); \
	else \
		echo "Python $(PYTHON_VERSION) is already installed."; \
	fi
	@pyenv local $(PYTHON_VERSION)
	@poetry env use $(PYTHON_VERSION)
	@poetry install

.PHONY: pre-commits
pre-commits: # Install and run pre-commit hooks
	@echo "\n🚀 Installing pre-commits"
	pre-commit install
	pre-commit run --all-files

.PHONY: dependency-install
dependency-install: pre-commit-install pyenv-install poetry-install

# Checks and installs the required dependencies, creates a virtual env, and installs pre-commit hooks.
.PHONY: project-setup
project-setup: dependency-install env-setup pre-commits


.PHONY: tests
tests: # Run all tests defined in the tests directory
	@poetry run python -m pytest

.PHONY: license-check
license-check: # Check that project dependencies all have licenses compatible with project LICENSE.txt (or lack thereof)
	@licensecheck -u poetry:dev

.PHONY: help
help: # Show help for each of the Makefile recipes.
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
