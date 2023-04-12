#!/usr/bin/env zsh

echo "\nInstalling packages/applications...\n"

if exists brew; then
    # Install from Brewfile
    # TODO: is exporting this env var going to work for `brew bundle` installs?
    # Disable Apple "trusted app" post-installation dialogues
    export HOMEBREW_CASK_OPTS="--no-quarantine"
    brew bundle install --verbose --file=./Homebrew/Brewfile

    # brew cleanup --dry-run to know what would be removed
    echo "\nCleaning up...\n"
    brew cleanup --verbose
else
    echo "brew not found..."
fi

# TODO: explore tips found here: https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f