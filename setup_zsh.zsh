#!/usr/bin/env zsh

echo "\n<<< Starting ZSH Setup >>>\n"

# Installation unnecessary, it's already in the Brewfile.

# Add Homebrew-installed ZSH to /etc/shells
if grep -Fxq '/opt/homebrew/bin/zsh' '/etc/shells'; then
    echo "Homebrew-installed ZSH already exists in /etc/shells"
else
    echo "Enter superuser (sudo) password to edit /etc/shells"
    echo '/opt/homebrew/bin/zsh' | sudo tee -a '/etc/shells' >/dev/null
fi

# Make Homebrew-installed ZSH the default login shell for this user
if [ "$SHELL" = '/opt/homebrew/bin/zsh' ]; then
    echo "Homebrew-installed ZSH is already set as the default login shell for $USER"
else
    echo "Enter user password to change login shell"
    chsh -s '/opt/homebrew/bin/zsh'
fi

# Make sh point to /bin/zsh instead of /bin/bash by default
if sh --version | grep -q zsh; then
    echo "sh already points to /bin/zsh"
else
    echo "Enter superuser (sudo) password to symlink sh to zsh"
    # Looked cute, might delete later, idk
    sudo ln -sfv /bin/zsh /private/var/select/sh

    # I'd like for this to work instead.
    # sudo ln -sfv /opt/homebrew/bin/zsh /private/var/select/sh
fi