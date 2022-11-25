#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with 'Volta', which is in the Brewfile.
# See zprofile for $VOLTA_HOME variable.
# The path to Volta shims is included in the $path array in zshrc.

# if the Node command exists and it's not the Homebrew-installed version
if exists node && ! which node | grep --quiet "homebrew"; then
    echo "Node $(node --version) & NPM $(npm --version) already installed"
else
    echo "Installing the latest LTS versions of Node & NPM using Volta..."
    volta install node
    volta install npm
fi
# TODO: add another similar check for npm as well?

# Install Global NPM Packages
npm install --global trash-cli

echo "Global NPM Packages Installed"
npm list --global --depth=0