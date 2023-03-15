#!/usr/bin/env zsh

echo "\n<<< Cloning the Scripts directory... >>>\n"

# if the directory doesn't exist
if [ ! -d "$HOME/Scripts" ]; then
    git clone git@github.com:MurtadhaInit/scripts.git "$HOME/Scripts"
else
    echo "~/Scripts is already in place"
fi
