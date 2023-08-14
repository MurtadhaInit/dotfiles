# Load Homebrew and add its tools to $path
eval "$(/opt/homebrew/bin/brew shellenv)"

# Load pyenv
eval "$(pyenv init -)"
# we want pyenv after Anaconda for the `conda` command to be
# parsed by pyenv shims

# pyenv-virtualenv: enable auto-activation
if which pyenv-virtualenv-init > /dev/null; then eval "$(pyenv virtualenv-init -)"; fi

# Load direnv
eval "$(direnv hook zsh)"

# Load fnm
eval "$(fnm env --use-on-cd)"