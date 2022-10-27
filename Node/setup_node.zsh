#!/usr/bin/env zsh

echo "\n<<< Starting Node Setup >>>\n"

# Node versions are managed with 'nvm', which is in the Brewfile.
# See zshrc for NVM_DIR variable and the loading of nvm.

if exists node; then
    echo "Node $(node --version) & NPM $(npm --version) already installed"
else
    echo "Installing latest version of Node & NPM with nvm..."
    nvm install node
fi

# Install Global NPM Packages
npm install --global firebase-tools
npm install --global @angular/cli
npm install --global @ionic/cli
npm install --global typescript
npm install --global json-server
npm install --global http-server
npm install --global trash-cli

echo "Global NPM Packages Installed"
npm list --global --depth=0