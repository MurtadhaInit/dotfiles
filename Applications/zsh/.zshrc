# Interactive shells. Nushell is the daily shell; this mirrors its setup
# (Applications/nushell/config.nu) for the times zsh is used directly.

[[ -d $XDG_STATE_HOME/zsh && -d $XDG_CACHE_HOME/zsh ]] || mkdir -p "$XDG_STATE_HOME/zsh" "$XDG_CACHE_HOME/zsh"

# === History ===
# Atuin owns search; this file is only zsh's own fallback, shared across sessions like nu's.
HISTFILE="$XDG_STATE_HOME/zsh/history"
HISTSIZE=100000
SAVEHIST=100000
setopt SHARE_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS

# === Vi mode ===
bindkey -v
KEYTIMEOUT=1 # 10ms, so Esc switches to normal mode without a lag
# vi-mode backspace stops where insert mode began; use the unrestricted one as nu does
bindkey -M viins '^?' backward-delete-char '^H' backward-delete-char
bindkey -M viins '^[^?' backward-kill-word # alt+backspace
bindkey -M vicmd '_' vi-first-non-blank

# Cursor per mode, as in nu: blinking bar (insert), blinking underline (normal)
autoload -Uz add-zle-hook-widget
_cursor_shape() { [[ $KEYMAP == vicmd ]] && print -n '\e[3 q' || print -n '\e[5 q' }
add-zle-hook-widget keymap-select _cursor_shape
add-zle-hook-widget line-init _cursor_shape

# === Completion ===
# brew shellenv only extends fpath in login shells
typeset -U fpath
fpath=("$HOMEBREW_PREFIX/share/zsh/site-functions" "$HOME/.nix-profile/share/zsh/site-functions" $fpath)
autoload -Uz compinit
compinit -d "$XDG_CACHE_HOME/zsh/zcompdump-$ZSH_VERSION"
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/zcompcache"
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*' # case-insensitive, then partial
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense'
export CARAPACE_MATCH=1 # case-insensitive
(( $+commands[carapace] )) && source <(carapace _carapace zsh)

# === Tools ===
(( $+commands[direnv] )) && eval "$(direnv hook zsh)"
(( $+commands[mise] )) && eval "$(mise activate zsh)"
(( $+commands[zoxide] )) && eval "$(zoxide init zsh)"
(( $+commands[atuin] )) && eval "$(atuin init zsh)"
(( $+commands[starship] )) && eval "$(starship init zsh)"

# fzf theme (Catppuccin mocha)
export FZF_DEFAULT_OPTS="
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4"

# Ghostty injects its integration only into the shell it launches (nu), not a zsh run inside it
[[ -n $GHOSTTY_RESOURCES_DIR ]] && source "$GHOSTTY_RESOURCES_DIR/shell-integration/zsh/ghostty-integration"

# === Aliases ===
alias tree='tree -aC'
alias lzg=lazygit
alias lzd=lazydocker
alias man=batman
alias k=kubectl
alias t=talosctl
# nvim with the separate config used inside VS Code, to update/debug it
alias nvim-vscode='NVIM_APPNAME=nvim-vscode nvim'
# Update the Brewfile after adding a package
alias bbd='brew bundle dump --force --no-vscode --no-go --no-npm --file="$HOME/.dotfiles/Homebrew/Brewfile"'
alias dot="$HOME/.dotfiles/system-setup/setup.nu"
alias eza='eza --long --all --header --group --group-directories-first --color-scale=all --color-scale-mode=gradient --hyperlink --sort=modified --reverse --git --icons=auto --time-style="+%d %b %y %l:%M%P"'
alias ls=eza
alias lsc='eza --loc'

# === Plugins (pinned by hm-modules/zsh.nix) ===
# Order matters: the theme configures the highlighter, which must load after every other widget.
source "$XDG_DATA_HOME/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$XDG_DATA_HOME/zsh/plugins/catppuccin_mocha-zsh-syntax-highlighting.zsh"
source "$XDG_DATA_HOME/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
