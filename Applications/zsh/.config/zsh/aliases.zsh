alias ls=exa
alias exa='exa -lah --git --icons --group-directories-first'
alias lg='lazygit'
alias man=batman
alias grep='grep --color'
# Update the Brewfile after adding a package
alias bbd='brew bundle dump --force --describe --file=~/.dotfiles/Homebrew/Brewfile'
alias brew_outdated='brew update &>/dev/null && brew outdated'

# Using parameter expansion, apply the newline-separator option to the lowercase array version of 'path' and redirect the result to standard output using hereword (the default for which we've changed to bat).
alias trail='<<<${(F)path}'
