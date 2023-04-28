#!/usr/bin/env bash

# curl https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash > bootstrap.bash && chmod +x bootstrap.bash && ./bootstrap.bash && rm bootstrap.bash

# check if a command exists
function exists() {
  command -v "$1" >/dev/null 2>&1
  # This is equivalent to:
  # command -v $1 1>/dev/null 2>/dev/null
}

# Install Homebrew if on MacOS and if not installed
# TODO: transfer the installation of Homebrew to the macos playbook and use virtualenv to install Ansible agnosticly after checking for the existence of Python 3
if exists brew; then
    echo "brew exists, skipping install..."
else
    echo "Installing Homebrew..."
    # To achieve a non-interactive run of the Homebrew installer
    # that doesn’t prompt for passwords
    export NONINTERACTIVE=1
    # Run the installer
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    # Disable Homebrew analytics
    brew analytics off
fi

# TODO: install Ansible in a virtual env instead then delete it afterwards
# Install pipx
brew install pipx
export PATH="$HOME/.local/bin:$PATH"

# Install Ansible
pipx install --include-deps ansible

# Clone the repo and execute local.yml
ansible-pull --url https://github.com/MurtadhaInit/dotfiles.git --directory $HOME/.dotfiles --ask-become-pass