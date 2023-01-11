# Load Homebrew and add its tools to $path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load Anaconda
# >>> conda initialize >>>
# # # !! Contents within this block are managed by 'conda init' !!
# __conda_setup="$('/Users/murtadha/.local/share/pyenv/versions/anaconda3-2022.05/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
# if [ $? -eq 0 ]; then
#     eval "$__conda_setup"
# else
#     if [ -f "/Users/murtadha/.local/share/pyenv/versions/anaconda3-2022.05/etc/profile.d/conda.sh" ]; then
#         . "/Users/murtadha/.local/share/pyenv/versions/anaconda3-2022.05/etc/profile.d/conda.sh"
#     else
#         export PATH="/Users/murtadha/.local/share/pyenv/versions/anaconda3-2022.05/bin:$PATH"
#     fi
# fi
# unset __conda_setup
# <<< conda initialize <<<
# The base environment is not activated by default
# conda config --set auto_activate_base False

# Load pyenv
eval "$(pyenv init -)"
# we want pyenv after Anaconda for the `conda` command to be
# parsed by pyenv shims

# pyenv-virtualenv: enable auto-activation
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Load goenv
eval "$(goenv init -)"