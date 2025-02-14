alias ls='eza -lahg --group-directories-first --git --icons=auto --time-style="+%d-%b-%Y %l:%M%P"'
alias tree='tree -daC'
alias lzg='lazygit'
alias lzd='lazydocker'
alias zj='zellij'
alias zjt='zellij run --floating --close-on-exit --cwd "$HOME/Scripts/utility_scripts/zellij-new-tab/" -- ./zellij-new-tab'
alias man=batman
alias grep='grep --color'

# To open nvim with the separate nvim-vscode config to update/debug nvim as used inside VSCode
alias nvim-vscode='NVIM_APPNAME="nvim-vscode" nvim' 

# Update the Brewfile after adding a package
alias bbd='brew bundle dump --force --describe --file=~/.dotfiles/Homebrew/Brewfile'
# Show outdated formulas & casks
alias brew_outdated='brew update &>/dev/null && brew outdated'

# Using parameter expansion, apply the newline-separator option to the lowercase array version of 'path' and redirect the result to standard output using hereword (the default for which we've changed to bat).
alias trail='<<<${(F)path}'

# dotfiles script
alias dot="$HOME/.dotfiles/system-setup/start.nu --select"