#!/usr/bin/env bash

# curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/refs/heads/main/bootstrap.bash | bash

# This script will:
# 1. Install Git, Homebrew (on MacOS), and nu
# 2. Clone the dotfiles repo
# 3. Initiate the setup process

# check if a command exists
function exists() {
  command -v "$1" >/dev/null 2>&1
  # This is equivalent to:
  # command -v $1 1>/dev/null 2>/dev/null
}

OS_TYPE=$(uname)
case "$OS_TYPE" in
  ("Darwin")
    # Install Homebrew without user interaction
    # This will also install Xcode Command Line Tools if not present TODO: confirm so
    if ! exists brew; then
      echo "Installing Homebrew..."
      NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
      eval "$(/opt/homebrew/bin/brew shellenv)"
      brew analytics off
    fi
    
    if ! exists git; then
      echo "Installing Git..."
      brew install git
    fi
    
    if [ ! -d "$HOME/.dotfiles" ]; then
      git clone --recursive https://github.com/MurtadhaInit/dotfiles.git "$HOME/.dotfiles"
    else
      echo "Dotfiles directory present ✅"
    fi

    if ! exists nu; then
      echo "Installing Nushell..."
      brew install nushell
    fi

    if [ "$#" -eq 0 ]; then
        # No arguments provided
        "$HOME"/.dotfiles/system-setup/setup.nu --skip
        # "$HOME"/.dotfiles/system-setup/start.nu --skip-tasks ["8-all-apps"]
    else
        # Pass all arguments to the nushell script
        "$HOME"/.dotfiles/system-setup/setup.nu "$@"
    fi
    ;;
  ("Linux")
    # IMPORTANT: this assumes a Fedora system (with DNF)
    # TODO: refactor to specifically run this block on Fedora-like distributions only
    if ! exists git; then
      echo "Installing Git..."
      sudo dnf install git -y
    fi

    if [ ! -d "$HOME/.dotfiles" ]; then
      git clone --recursive https://github.com/MurtadhaInit/dotfiles.git "$HOME/.dotfiles"
    else
      echo "Dotfiles directory present ✅"
    fi

    if ! exists ansible-playbook; then
      echo "Installing Ansible..."
      sudo dnf install ansible -y
    fi

    ansible-playbook --ask-become "$HOME/.dotfiles/system-setup/linux-setup/local.yml"
    ;;
  ("CYGWIN"* | "MINGW"* | "MSYS"*)
    # Windows-specific actions
    ;;
  (*)
    echo "Unknown OS: $OS_TYPE"
    exit 1
    ;;
esac
