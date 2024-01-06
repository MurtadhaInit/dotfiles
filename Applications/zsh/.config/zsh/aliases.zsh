alias ls='eza -lah --group-directories-first --git --icons=auto --time-style="+%d-%b-%Y %l:%M%P"'
alias tree='tree -daC'
alias lzg='lazygit'
alias lzd='lazydocker'
alias man=batman
alias grep='grep --color'
# Update the Brewfile after adding a package
alias bbd='brew bundle dump --force --describe --file=~/.dotfiles/Homebrew/Brewfile'
alias brew_outdated='brew update &>/dev/null && brew outdated'

# Using parameter expansion, apply the newline-separator option to the lowercase array version of 'path' and redirect the result to standard output using hereword (the default for which we've changed to bat).
alias trail='<<<${(F)path}'
