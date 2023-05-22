#!/usr/bin/env bash

# On a fresh system, this script assumes the existence of Python and Git.
# It creates a virtualenv in a temporary directory and installs Ansible
# within it. It then clones the dotfiles repo if not present already.
# Running ansible-playbook is a separate command to give flexibility in
# terms of arguments and avoid obscuring it inside the script.

# NOTE: we can't use ansible-pull because we can't pass options
# that require interaction to ansible-pull (e.g. --ask-vault-pass
# or even --ask-become-pass) despite misleading docs.

# *********** What to run on a new system ***********

# ===== First run =====
# curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash && $HOME/ansible-temp/ansible-setup/bin/ansible-playbook ~/.dotfiles/local.yml --ask-become-pass --ask-vault-pass --skip-tags all_apps

# ===== Subsequent runs =====
# $HOME/ansible-temp/ansible-setup/bin/ansible-playbook ~/.dotfiles/local.yml --ask-become-pass --ask-vault-pass --skip-tags all_apps

# If Python, pipx, and ansible (through pipx) were successfully
# installed, replace the above with just ansible-playbook and
# delete ~/ansible-temp

# Sign in with Apple ID and remove --skip-tags all_apps to do a full install

# ***************************************************

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

python3 -m virtualenv ansible-setup
source ansible-setup/bin/activate

pip install ansible

deactivate

if exists git; then
  if [ ! -d "$HOME/.dotfiles" ]; then
    git clone https://github.com/MurtadhaInit/dotfiles.git "$HOME/.dotfiles"
  fi
else
  echo "Git needs to be installed"
  exit
fi

# when done...
# rm -rf ansible-temp
