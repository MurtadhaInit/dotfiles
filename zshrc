echo 'Hello from .zshrc!'

# Set Variables
export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat

local brew_bin_path="/opt/homebrew/bin"
local brew_opt_path="/opt/homebrew/opt"
export NVM_DIR="$HOME/.nvm"
# Note: $(brew --prefix nvm) is /opt/homebrew/opt/nvm
# Automate: mkdir "$HOME/.nvm"
[ -s "${brew_opt_path}/nvm/nvm.sh" ] && \. "${brew_opt_path}/nvm/nvm.sh"  # This loads nvm
[ -s "${brew_opt_path}/nvm/etc/bash_completion.d/nvm" ] && \. "${brew_opt_path}/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

# Change ZSH Options

# Create Aliases
# alias ls='ls -lAFh'
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias man=batman
alias bbd='brew bundle dump --force --describe'
# Using parameter expansion, apply the newline-separator option to the lowercase array version of 'path' and redirect the result to standard output using hereword (the default for which we've changed to bat).
alias trail='<<<${(F)path}'
# Don't get accustomed to a more forgivable version of rm if you do server work.
alias rm=trash

# Customise Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Locations to $PATH Variable
# Add Visual Studio Code (code)
export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"

# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

# Use ZSH Plugins

# ...and Other Surprises

# Java
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home
export PATH=$JAVA_HOME/bin:$PATH

# Python
export PATH=$(brew --prefix)/opt/python/libexec/bin:$PATH
# "brew --prefix" is where Homebrew is installed. That's /opt/homebrew on Apple silicone macs

# Load Starship
# eval "$(starship init zsh)"
