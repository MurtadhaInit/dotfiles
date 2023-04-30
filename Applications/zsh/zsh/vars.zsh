export HOMEBREW_NO_ANALYTICS=1  # Disable Homebrew Google analytics
export HOMEBREW_CASK_OPTS="--no-quarantine" # Disable Apple "trusted app" post-installation dialogues

export NULLCMD=bat  # Default to bat instead of cat
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml" # Starship config

export POETRY_CONFIG_DIR="$HOME/.config/pypoetry"  # poetry config directory
export PYENV_ROOT="$XDG_DATA_HOME/pyenv"  # pyenv root directory
export VOLTA_HOME="$XDG_DATA_HOME/volta"  # Volta root directory
export GOBREW_ROOT="$XDG_DATA_HOME/gobrew"  # gobrew root directory
export GOROOT="$GOBREW_ROOT/.gobrew/current/go"  # Set GOROOT according to the active version of Go set by gobrew
export VAGRANT_HOME="$XDG_DATA_HOME/vagrant"  # Vagrant root directory
# export DOCKER_CONFIG="$XDG_CONFIG_HOME/docker"  # Docker
export LESSHISTFILE="$XDG_CACHE_HOME/less/history"  # less history directory
export JUPYTER_CONFIG_DIR="$XDG_CONFIG_HOME/jupyter"  # Jupyter config directory

# fzf Catppuccin (Frappé) colours: https://github.com/catppuccin/fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
--color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
--color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# fzf Catppuccin (Mocha) colours: https://github.com/catppuccin/fzf
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# fzf Catppuccin (Macchiato) colours: https://github.com/catppuccin/fzf
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
# --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
# --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
