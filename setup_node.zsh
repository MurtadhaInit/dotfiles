#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with 'nvm', which is in the Brewfile.
# See zshrc for NVM_DIR variable and the loading of nvm.

if exists node; then
    echo "Node $(node --version) & NPM $(npm --version) already installed"
else
    echo "Installing Node & NPM with nvm..."
    nvm install node
fi
