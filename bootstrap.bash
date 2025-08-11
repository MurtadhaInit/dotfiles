#!/usr/bin/env bash

# /bin/bash -c "$(curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/refs/heads/main/bootstrap.bash)"

# This script will:
# 1. Install Homebrew and then Git (with Homebrew)
# 2. Clone the dotfiles repo to ~/.dotfiles
# 3. Install Nushell with Homebrew
# 4. Initiate the setup process with Nu scripts (plus Ansible for Linux)

# check if a command exists
function exists() {
  command -v "$1" >/dev/null 2>&1
  # This is equivalent to:
  # command -v $1 1>/dev/null 2>/dev/null
}

OS_TYPE=$(uname)
case "$OS_TYPE" in
  ("Darwin")
    brew_binary=/opt/homebrew/bin/brew
    ;;
  ("Linux")
    brew_binary=/home/linuxbrew/.linuxbrew/bin/brew
    ;;
  ("CYGWIN"* | "MINGW"* | "MSYS"*)
    echo "⚠️ Windows not supported"
    exit 1
    ;;
  (*)
    echo "⚠️ Unknown OS: $OS_TYPE"
    exit 1
    ;;
esac

# This will presumably also install Xcode Command Line Tools (on macOS) if not present
if ! exists brew; then
  echo "🔄 Installing Homebrew..."
  NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
eval "$($brew_binary shellenv)"
brew analytics off

if ! exists git; then
  echo "🔄 Installing Git..."
  brew install git
fi

if [ ! -d "$HOME/.dotfiles" ]; then
  git clone --recursive https://github.com/MurtadhaInit/dotfiles.git "$HOME/.dotfiles"
else
  echo "✅ Dotfiles directory present"
fi

if ! exists nu; then
  echo "🔄 Installing Nushell..."
  brew install nushell
fi

if [ "$#" -eq 0 ]; then
    # No arguments provided
    "$HOME"/.dotfiles/system-setup/setup.nu --skip
else
    # Pass all arguments to the nushell script
    "$HOME"/.dotfiles/system-setup/setup.nu "$@"
fi

# ansible-playbook --ask-become "$HOME/.dotfiles/system-setup/linux-setup/local.yml"