alias ls=exa
alias exa='exa -lah --git --group-directories-first'
alias man=batman
alias grep='grep --color'
alias bbd='brew bundle dump --force --describe --file=~/.dotfiles/Homebrew/Brewfile'  # Update the Brewfile
alias uninstall='$HOME/Scripts/utility_scripts/app-cleaner.sh'  # Remove apps
alias obsidian_backup='$HOME/Scripts/periodic_scripts/obsidian_sync.zsh'

# Using parameter expansion, apply the newline-separator option to the lowercase array version of 'path' and redirect the result to standard output using hereword (the default for which we've changed to bat).
alias trail='<<<${(F)path}'
