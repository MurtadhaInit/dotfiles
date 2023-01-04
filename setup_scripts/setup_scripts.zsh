#!/usr/bin/env zsh

echo "\n<<< Fetching the Scripts directory >>>\n"

# if the directory doesn't exist
if [ ! -d "$HOME/Scripts" ]; then
    git clone git@github.com:MurtadhaInit/scripts.git "$HOME/Scripts"
else
    echo "~/Scripts is already in place"
fi

# add the obsidian_sync script as a cron job