# man zshoptions

# Set the location for .zcompcache
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
# Set the location for .zsh_history
# TODO: this keeps generating a .zsh_history file in $ZOTDIR for some reason
export HISTFILE="$XDG_STATE_HOME/zsh/history"
# case insensitive path completion
zstyle ':completion:*' matcher-list 'm:{[:lower:][:upper:]}={[:upper:][:lower:]}' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*' 'm:{[:lower:][:upper:]}={[:upper:][:lower:]} l:|=* r:|=*'
# Use arrow keys to select from available completions
zstyle ':completion:*' menu yes select
# place additional command completion scripts here. # TODO: might delete
fpath+="$ZDOTDIR/.zfunc"
# and load the command completions scripts from Homebrew-installed tools
fpath=($HOMEBREW_PREFIX/share/zsh/site-functions $fpath)
# load the zsh command completion system and set the location for .zcompdump
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"

# autoload -U bashcompinit && bashcompinit

# === Command completions for other tools ===
# uv and uvx autocompletion
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"
# fzf autocompletion
[[ $- == *i* ]] && source "$(brew --prefix fzf)/shell/completion.zsh" 2> /dev/null
