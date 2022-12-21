echo '.zprofile stuff are loaded!'

# ===== Set Variables =====
# XDG-Ninja scheme
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_CACHE_HOME="$HOME/.cache"
# export XDG_RUNTIME_DIR="/run/user/$UID"

# Load all other environment variables
[ -f "$ZDOTDIR/vars.zsh" ] && source "$ZDOTDIR/vars.zsh"

# ===== Load CLI Tools =====
# Load other tools
[ -f "$ZDOTDIR/tools.zsh" ] && source "$ZDOTDIR/tools.zsh"