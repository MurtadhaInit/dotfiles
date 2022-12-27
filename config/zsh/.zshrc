echo '.zshrc stuff are loaded!'
pfetch

# ===== Change ZSH Options =====
# man zshoptions

# ===== Create Aliases =====
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# ===== Add Locations to $path Array =====
# This enforces uniqueness on the array:
# Duplicate items added to the right are removed,
# while duplicate items added to the left are kept and
# the equivalents on the right are removed.
typeset -U path
path=(
  "$VOLTA_HOME/bin" # Volta shims
  "$HOME/.local/bin" # pipx tools/apps
  "$(brew --prefix fzf)/bin" # fzf
  "$(brew --prefix openjdk)/bin" # Homebrew JDK
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" # VSCode
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" # JetBrains
  $path
)

# ===== Handy Functions =====
[ -f "$ZDOTDIR/functions.zsh" ] && source "$ZDOTDIR/functions.zsh"

# ===== Command Completion =====
# case insensitive path completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# place additional command completion scripts here
fpath+="$ZDOTDIR/.zfunc"
# load the zsh command completion system
autoload -Uz compinit && compinit
# load bash completions since they are compatible with zsh
# so far, this is only used for pipx completions
autoload -U bashcompinit && bashcompinit
# pipx autocompletion
eval "$(register-python-argcomplete pipx)"
# fzf autocompletion
[[ $- == *i* ]] && source "$(brew --prefix fzf)/shell/completion.zsh" 2> /dev/null

# fzf key bindings
source "$(brew --prefix fzf)/shell/key-bindings.zsh"

# The default Python interpreter to use by pipx
# TODO: Replace with more perm one
export PIPX_DEFAULT_PYTHON="$(pyenv which python)"

# ===== Customise Prompt(s) =====
# Load Starship
eval "$(starship init zsh)"

# ===== ZSH Plugins / CLI Tools =====
# Load zoxide
eval "$(zoxide init zsh)"
# Load zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH Syntax Highlighting: it has to be the last sourced file in .zshrc
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# NOTE: These fzf config files are generated by the install script,
# which is located at: $(brew --prefix)/opt/fzf/install
# They are originally placed in the home directory.
# No need to execute the install script again after
# installation of fzf with Homebrew.
# Those scripts were then placed in $HOME/.config/fzf/.fzf.zsh and sourced.

# NOTE: That line that loads zoxide must be added after compinit
# is called. A rebuild of the cache might be required by running
# rm ~/.zcompdump*; compinit

# Java
# export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-18.0.1.1.jdk/Contents/Home
# export PATH=$JAVA_HOME/bin:$PATH

# For the system Java wrappers to find this JDK, symlink it with
# sudo ln -sfn /opt/homebrew/opt/openjdk/libexec/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk.jdk

# For compilers to find openjdk you may need to set:
# export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"

