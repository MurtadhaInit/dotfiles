# export BREW_PREFIX=$(brew --prefix) # Save Homebrew’s installed location
export HOMEBREW_NO_ANALYTICS=1  # Disable Homebrew Google analytics
export HOMEBREW_CASK_OPTS="--no-quarantine" # Disable Apple "trusted app" post-installation dialogues
export NULLCMD=bat  # Default to bat instead of cat
export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml" # Starship config
export POETRY_CONFIG_DIR="$HOME/.config/pypoetry"  # poetry config directory
export PYENV_ROOT="$HOME/.pyenv"  # pyenv root directory
export VOLTA_HOME="$HOME/.volta"  # Volta root directory
