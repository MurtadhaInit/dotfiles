#!/usr/bin/env bash

# check if a command exists
function exists() {
  command -v "$1" >/dev/null 2>&1
  # This is equivalent to:
  # command -v $1 1>/dev/null 2>/dev/null
}

# Install Homebrew if on MacOS and if not installed
# TODO: add a condition to check the type of OS to install Ansible accordingly
if exists brew; then
    echo "brew exists, skipping install..."
else
    echo "Installing Homebrew..."
    # To achieve a non-interactive run of the Homebrew installer
    # that doesn’t prompt for passwords
    export NONINTERACTIVE=1
    # Run the installer
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install pipx
brew install pipx
export PATH="$HOME/.local/bin:$PATH"

# Install Ansible
pipx install --include-deps ansible

# Clone the repo and execute local.yml
ansible-pull --url https://github.com/MurtadhaInit/dotfiles.git --directory $HOME/.dotfiles --ask-become-pass