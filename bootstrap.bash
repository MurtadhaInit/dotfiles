#!/usr/bin/env bash

# curl https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash > bootstrap.bash && chmod +x bootstrap.bash && ./bootstrap.bash && rm bootstrap.bash

# curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash

# check if a command exists
function exists() {
  command -v "$1" >/dev/null 2>&1
  # This is equivalent to:
  # command -v $1 1>/dev/null 2>/dev/null
}

if ! exists python3; then
  echo "Python needs to be installed"
  exit
fi

if [ ! -d "$HOME/ansible-temp" ]; then
  mkdir "$HOME/ansible-temp"
fi

cd "$HOME/ansible-temp" || exit

if ! exists pip; then
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py --user
fi

python3 -m pip install --upgrade pip

if ! pip show virtualenv 1>/dev/null 2>&1; then
  pip install virtualenv
fi

if ! pip show setuptools 1>/dev/null 2>&1; then
  pip install setuptools
fi

# NOTE: virtualenv (along with setuptools) are also needed by a task using the pip module

python3 -m virtualenv ansible-setup
source ansible-setup/bin/activate

pip install ansible

# Clone the repo and execute local.yml
ansible-pull --url https://github.com/MurtadhaInit/dotfiles.git --directory $HOME/.dotfiles --ask-become-pass

deactivate

# when done...
# rm -rf ansible-temp
