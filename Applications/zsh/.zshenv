# Read by every zsh, scripts included: exports only, nothing that prints or needs a TTY.
# PATH belongs in .zprofile (see there).

# launchd seeds the same XDG dirs for GUI apps on macOS (darwin-modules/xdg.nix)
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export XDG_BIN_HOME="$HOME/.local/bin"
[[ $OSTYPE == darwin* ]] && export XDG_RUNTIME_DIR="$HOME/.local/run"

export VISUAL="zed --wait"
export EDITOR=nvim

export HOMEBREW_NO_ANALYTICS=1
export STARSHIP_CONFIG="$XDG_CONFIG_HOME/starship/starship.toml"
export EZA_CONFIG_DIR="$XDG_CONFIG_HOME/eza"
