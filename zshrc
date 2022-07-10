echo 'Hello from .zshrc!'

# Set Variables

# Change ZSH Options

# Create Aliases
alias ls='ls -lAFh'

# Customise Prompt(s)
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# Add Locations to $PATH Variable

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
