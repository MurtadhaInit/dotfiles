#!/usr/bin/env zsh

echo "\n<<< Starting Python Setup >>>\n"

# === Install Python ===
# install the latest version of Python for system-wide usage + pipx
pyenv install --skip-existing 3.11:latest
# TODO: set it as the global version in pyenv

# === Install Anaconda with pyenv ===
# conda config --set changeps1 False
# This is to get rid of the line added to the prompt indicating the conda environment currently activated (we obtain this info from Starship).


# === Install Python applications with pipx ===
pipx install --include-deps ansible
pipx install ansible-lint
pipx install apprise
# --- Install poetry ---
if exists poetry; then
    echo "$(poetry --version) is already installed"
else
    echo "Installing Poetry (Python packaging and dependency management)..."
    # install with pipx
    pipx install poetry
    # restart the shell to have the poetry command sourced in $path
    exec $SHELL
    # generate zsh command completion script to include in $fpath
    if [ "$(which $SHELL)" = "$(brew --prefix)/bin/zsh" ]; then
        # if current shell is Homebrew-installed zsh, add completions there
        poetry completions zsh > $(brew --prefix)/share/zsh/site-functions/_poetry
    else
        # otherwise, add it in the default directory for user-defined completions
        poetry completions zsh > "$ZDOTDIR/.zfunc/_poetry"
    fi
    echo "$(poetry --version) has been installed"
fi