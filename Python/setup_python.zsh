#!/usr/bin/env zsh

echo "\n<<< Starting Python Setup >>>\n"

# === Install Python ===
# Use regular expressions with pyenv to install the latest version of Python for system-wise usage
# pyenv install 3...


# Install with pipx:
# pipx install --include-deps ansible
# pipx install ansible-lint

# === Install Anaconda with pyenv ===
# conda config --set changeps1 False
# This is to get rid of the line added to the prompt indicating the conda environment currently activated (we obtain this info from Starship).

# === Install poetry ===
# - Python 3.7+ is required
# - Poetry is installed to an isolated Python venv environment
if exists poetry; then
    echo "$(poetry --version) is already installed"
else
    echo "Installing Poetry (Python packaging and dependency management)..."
    # install with pipx
    pipx install poetry
    # start a subshell to have the poetry command sourced in $path
    zsh
    # generate zsh command completion script to include in $fpath
    poetry completions zsh > ~/.zfunc/_poetry
    echo "$(poetry --version) has been installed"
fi