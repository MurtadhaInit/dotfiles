echo '.zshrc stuff are loaded!'

# ===== Change ZSH Options =====
# man zshoptions

# ===== Create Aliases =====
# alias ls='ls -lAFh'
alias ls='exa -laFh --git'
alias exa='exa -laFh --git'
alias man=batman
alias bbd='brew bundle dump --force --describe'
# Using parameter expansion, apply the newline-separator option to the lowercase array version of 'path' and redirect the result to standard output using hereword (the default for which we've changed to bat).
alias trail='<<<${(F)path}'
# Don't get accustomed to a more forgivable version of rm if you do server work.
# alias rm=trash

# ===== Customise Prompt(s) =====
PROMPT='
%1~ %L %# '

RPROMPT='%*'

# ===== Add Locations to $path Array =====

# This enforces uniqueness on the array:
# Duplicate items added to the right are removed,
# while duplicate items added to the left are kept and
# the equivalents on the right are removed.
typeset -U path
path=(
  $path
  "$(brew --prefix openjdk)/bin" # Homebrew JDK
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" # VSCode
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" # JetBrains
  "$HOME/.local/bin"  # Poetry
)

# ===== Handy Functions =====
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

# For now: this is for loading command completion for poetry
fpath+=~/.zfunc
autoload -Uz compinit && compinit

# ===== ZSH Plugins =====
# Load fzf configs: fzf setup (if needed), auto-completion and key bindings
- [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Load zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH Syntax Highlighting: it has to be the last sourced file in .zshrc
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH

# For the system Java wrappers to find this JDK, symlink it with
# sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# For compilers to find openjdk you may need to set:
# export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"


# Load Starship
# eval "$(starship init zsh)"
