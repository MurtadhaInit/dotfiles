#!/usr/bin/env zsh

echo "\n<<< Starting Python Setup >>>\n"

# === Install Python ===
# Use regular expressions with pyenv to install the latest version of Python for system-wise usage
# pyenv install 3...


# === Install poetry ===
# - Python 3.7+ is required
# - Poetry is installed to an isolated Python venv
# - $POETRY_HOME is set to $HOME/.poetry
# - $POETRY_HOME/poetry_bin is added to $path
if exists poetry; then
    echo "$(poetry --version) is already installed"
else
    echo "Installing Poetry (Python packaging and dependency management)..."
    python3 -m venv $POETRY_HOME
    $POETRY_HOME/bin/pip install -U pip setuptools
    $POETRY_HOME/bin/pip install poetry

    # This is to avoid adding the entire $POETRY_HOME/bin directory to $path,
    # which includes unneeded Python binaries (from poetry's venv).
    mkdir $POETRY_HOME/poetry_bin
    ln -s $POETRY_HOME/bin/poetry $POETRY_HOME/poetry_bin/poetry

    # Tab completion
    # These two lines are loaded in .zshrc:
        # fpath+=~/.zfunc
        # autoload -Uz compinit && compinit
    poetry completions zsh > ~/.zfunc/_poetry

    echo "$(poetry --version) has been installed"
fi


# === Install tldr-pages ===
if exists tldr; then
    echo "tldr pages already installed"
else
    echo "Installing tldr pages..."
    pip3 install tldr
fi