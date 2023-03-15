#!/usr/bin/env zsh

echo "\n<<< Loading and starting launchd agents... >>>\n"

# TODO: add a test for the existence of the .plist file and skip accordingly
# obsidian_sync script, executed every 7 minutes
ln -sf ~/Scripts/periodic_scripts/murtadha.obsidian.sync.plist ~/Library/LaunchAgents/murtadha.obsidian.sync.plist && launchctl enable ~/Library/LaunchAgents/murtadha.obsidian.sync.plist && launchctl start murtadha.obsidian.sync