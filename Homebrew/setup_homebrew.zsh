#!/usr/bin/env zsh

echo "\n<<< Starting Homebrew Setup >>>\n"

if exists brew; then
    echo "brew exists, skipping install..."
else
    echo "brew doesn't exist, continuing with install..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi


# TODO: Keep an eye out for a different '--no-quarantine' solution.
# Currently, you can't do 'brew bundle --no-quarantine' as an option.
# It's currently exported in zshrc:
# export HOMEBREW_CASK_OPTS="--no-quarantine"
# https://github.com/Homebrew/homebrew-bundle/issues/474

# Install from Brewfile
echo "\nInstalling packages/applications...\n"
brew bundle install --verbose --file=./Homebrew/Brewfile

# brew cleanup --dry-run to know what is removed
echo "\nCleaning up...\n"
brew cleanup --verbose

# TODO: explore brew bundle cleanup
# TODO: explore tips found here: https://gist.github.com/ChristopherA/a579274536aab36ea9966f301ff14f3f