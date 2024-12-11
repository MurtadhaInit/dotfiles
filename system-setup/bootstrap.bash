#!/usr/bin/env bash

# curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash && $HOME/ansible-temp/ansible-setup/bin/ansible-playbook ~/.dotfiles/local.yml --ask-become-pass --ask-vault-pass --skip-tags all_apps
# TODO: add something (this bash script or the nushell script) to PATH to facilitate easy future runs

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
    ;;
  ("Linux")
    # Linux-specific actions
    ;;
  ("CYGWIN"* | "MINGW"* | "MSYS"*)
    # Windows-specific actions
    ;;
  (*)
    echo "Unknown OS: $OS_TYPE"
    exit 1
    ;;
esac


if [ "$#" -eq 0 ]; then
    # No arguments provided
    "$HOME"/.dotfiles/system-setup/start.nu --skip-tasks ["8-all-apps"]
else
    # Pass all arguments to the nushell script
    "$HOME"/.dotfiles/system-setup/start.nu "$@"
fi