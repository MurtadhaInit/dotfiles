echo '.zprofile stuff are loaded!'

# ===== Set Variables =====
export HOMEBREW_CASK_OPTS="--no-quarantine"
export NULLCMD=bat  # Default to bat instead of cat

export PYENV_ROOT="$HOME/.pyenv"  # pyenv root directory
export NVM_DIR="$HOME/.nvm" # nvm root directory

# ===== Load Tools =====
# Load Homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# >>> conda initialize >>>
# # !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/murtadha/.pyenv/versions/anaconda3-2022.05/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/murtadha/.pyenv/versions/anaconda3-2022.05/etc/profile.d/conda.sh" ]; then
        . "/Users/murtadha/.pyenv/versions/anaconda3-2022.05/etc/profile.d/conda.sh"
    else
        export PATH="/Users/murtadha/.pyenv/versions/anaconda3-2022.05/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
# The base environment is not activated by default
# conda config --set auto_activate_base False

# Load pyenv
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"  # Do we even need this? pyenv itself is already in the Homebrew bin directory and by default $PYENV_ROOT/bin doesn't exist.
eval "$(pyenv init -)"

# Load pyenv-virtualenv
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Load nvm
# Note: $(brew --prefix nvm) is /opt/homebrew/opt/nvm
[ -s "$(brew --prefix nvm)/nvm.sh" ] && \. "$(brew --prefix nvm)/nvm.sh"  # This loads nvm
[ -s "$(brew --prefix nvm)/etc/bash_completion.d/nvm" ] && \. "$(brew --prefix nvm)/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

