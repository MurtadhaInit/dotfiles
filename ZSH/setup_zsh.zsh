#!/usr/bin/env zsh

echo "\n<<< Starting ZSH Setup >>>\n"

# The installation of ZSH through Homebrew is already included in the Brewfile.

# Add Homebrew-installed ZSH to /etc/shells
if grep -Fxq "$(brew --prefix)/bin/zsh" "/etc/shells"; then
    echo "Homebrew-installed ZSH already exists in /etc/shells"
else
    echo "Enter superuser (sudo) password to edit /etc/shells"
    echo "$(brew --prefix)/bin/zsh" | sudo tee -a "/etc/shells" >/dev/null
fi

# Make Homebrew-installed ZSH the default login shell for this user
if [ "$SHELL" = "$(brew --prefix)/bin/zsh" ]; then
    echo "Homebrew-installed ZSH is already set as the default login shell for $USER"
else
    echo "Enter user password to change login shell"
    chsh -s "$(brew --prefix)/bin/zsh"
fi

# export ZDOTDIR="$HOME/.config/zsh"
# TODO: this should be appended to /etc/zshenv which doesn't exist by default
# Using sudo with echo and >> doesn't seem to work. Find another way to script it
# Also, watch out if this file is reset / deleted with OS updates!

# Make sh point to /bin/zsh instead of /bin/bash by default
# if sh --version | grep -q zsh; then
#     echo "sh already points to /bin/zsh"
# else
#     echo "Enter superuser (sudo) password to symlink sh to zsh"
#     # Looked cute, might delete later, idk
#     sudo ln -sfv /bin/zsh /private/var/select/sh

    # FIXME: changing sh from pointing to bash to pointing to zsh will break a few things: for example, the installation of Python versions with pyenv. Reverting to bash fixed that.

    # I'd like for this to work instead.
    # sudo ln -sfv /opt/homebrew/bin/zsh /private/var/select/sh
# fi

# TODO: Use Dash as an sh shell (it's more POSIX compliant than Bash).