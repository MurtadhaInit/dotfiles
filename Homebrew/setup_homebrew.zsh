#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

if exists brew; then
    echo "brew exists, skipping install..."
else
    echo "brew doesn't exist, continuing with install..."
    # To achieve a non-interactive run of the Homebrew installer
    # that doesn’t prompt for passwords
    export NONINTERACTIVE=1
    # Run the installer
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install from Brewfile
# TODO: is exporting this env var going to work for `brew bundle` installs?
# Disable Apple "trusted app" post-installation dialogues
export HOMEBREW_CASK_OPTS="--no-quarantine"
echo "\nInstalling packages/applications...\n"
brew bundle install --verbose --file=./Homebrew/Brewfile

# brew cleanup --dry-run to know what would be removed
echo "\nCleaning up...\n"
brew cleanup --verbose

# TODO: explore tips found here: https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f