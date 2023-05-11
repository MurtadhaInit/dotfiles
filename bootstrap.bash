#!/usr/bin/env bash

# ===== First run =====
# curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash && ./ansible-temp/ansible-setup/bin/ansible-pull --url https://github.com/MurtadhaInit/dotfiles.git --directory $HOME/.dotfiles --ask-become-pass --skip-tags all_apps

# Sign in with Apple ID and remove --skip-tags all_apps to do a full install

# ===== Subsequent runs =====
# ./ansible-temp/ansible-setup/bin/ansible-playbook ~/.dotfiles/local.yml --ask-become-pass --skip-tags all_apps

# If Python, pipx, and ansible (through pipx) were successfully
# installed, replace the above with just ansible-playbook and
# delete ~/ansible-temp

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

if ! exists pip3; then
  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py
  python3 get-pip.py --user
fi

python3 -m pip install --upgrade pip

if ! pip3 show virtualenv 1>/dev/null 2>&1; then
  pip3 install virtualenv
fi

if ! pip3 show setuptools 1>/dev/null 2>&1; then
  pip3 install setuptools
fi

# NOTE: virtualenv (along with setuptools) are also needed by a task using the pip module

python3 -m virtualenv ansible-setup
source ansible-setup/bin/activate

pip install ansible

deactivate

# when done...
# rm -rf ansible-temp
