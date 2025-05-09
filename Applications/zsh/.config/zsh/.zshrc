# ===== Add Locations to $path Array =====
# This enforces uniqueness on the array:
# Duplicate items added to the right are removed,
# while duplicate items added to the left are kept and
# the equivalents on the right are removed.
typeset -U path
path=(
  "$HOME/.local/bin" # for a bunch of stuff including personal scripts
  "$XDG_CACHE_HOME/.bun/bin" # binaries of JS tools installed globally with `bun i -g`
  "$(brew --prefix fzf)/bin" # fzf
  "$(brew --prefix openjdk)/bin" # Homebrew JDK
  "$GOBREW_ROOT/.gobrew/bin" # gobrew binary
  "$GOBREW_ROOT/.gobrew/current/bin" # active version of Go set by gobrew
  "$ANDROID_HOME/emulator" # Android Development
  "$ANDROID_HOME/platform-tools" # Android Development
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin" # VSCode. # TODO: install through Homebrew and remove this
  "$HOME/Library/Application Support/JetBrains/Toolbox/scripts" # JetBrains
  $path
)

# ===== Customise Prompt(s) =====
eval "$(starship init zsh)"

# ===== Create Aliases =====
[ -f "$ZDOTDIR/aliases.zsh" ] && source "$ZDOTDIR/aliases.zsh"

# ===== Handy Functions =====
[ -f "$ZDOTDIR/functions.zsh" ] && source "$ZDOTDIR/functions.zsh"

# ===== Keybinds / Shortcuts =====
[ -f "$ZDOTDIR/keybinds.zsh" ] && source "$ZDOTDIR/keybinds.zsh"

# ===== ZSH Options & Command Completion =====
[ -f "$ZDOTDIR/options.zsh" ] && source "$ZDOTDIR/options.zsh"

# ===== ZSH Plugins / CLI Tools =====
# Load Atuin (command history)
eval "$(atuin init zsh)"
# Load zoxide
eval "$(zoxide init zsh)"
# Load zsh-autosuggestions
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
# ZSH Fast Syntax Highlighting: it has to be the last sourced file in .zshrc
# NOTE: themes are in: $XDG_CONFIG_HOME/fsh
# Change the theme with: fast-theme XDG:catppuccin-mocha
source $(brew --prefix)/share/zsh-fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh

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


