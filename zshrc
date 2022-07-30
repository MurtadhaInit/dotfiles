echo 'Hello from .zshrc!'

# Set Variables
export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat  # Default to bat instead of cat

export PYENV_ROOT="$HOME/.pyenv"  # pyenv root directory
export NVM_DIR="$HOME/.nvm" # nvm root directory

# >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/murtadha/.pyenv/versions/anaconda3-2022.05/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/murtadha/.pyenv/versions/anaconda3-2022.05/etc/profile.d/conda.sh" ]; then
        . "/Users/murtadha/.pyenv/versions/anaconda3-2022.05/etc/profile.d/conda.sh"
    else
        export PATH="/Users/murtadha/.pyenv/versions/anaconda3-2022.05/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# The base environment is not activated by default
# conda config --set auto_activate_base False

# Load pyenv
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"  # Do we even need this? pyenv itself is already in the Homebrew bin directory and by default $PYENV_ROOT/bin doesn't exist.
eval "$(pyenv init -)"

# Load pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Load nvm
# Note: $(brew --prefix nvm) is /opt/homebrew/opt/nvm
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

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

# Add Locations to $path Array

# This enforces uniqueness on the array:
# Duplicate items added to the right are removed,
# while duplicate items added to the left are kept and
# the equivalents on the right are removed.
typeset -U path
path=(
  "$(brew --prefix openjdk)/bin"
  $path
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
  "/Users/murtadha/Library/Application Support/JetBrains/Toolbox/scripts"
)

# Write Handy Functions
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

# Use ZSH Plugins

# ...and Other Surprises

# Java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH

# For the system Java wrappers to find this JDK, symlink it with
# sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# For compilers to find openjdk you may need to set:
# export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"


# Load Starship
# eval "$(starship init zsh)"
