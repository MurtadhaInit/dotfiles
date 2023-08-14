# My Ultimate Dotfiles & Development Machine Setup

This is my IaC workflow for automating and bootstrapping the full setup of my main machine using Ansible.

## In summary

This repository includes:

- _All my dotfiles_, which represent the configuration files used for various apps and CLI tools I regularly use on my computer.
  - Among these dotfiles is my [NeoVim config](https://github.com/MurtadhaInit/nvim) in the form of a Git submodule. It is separated into a its own Git repository.
- _A Brewfile_. This stores a list of every GUI and CLI application I have installed on my MacOS machine, as well as all my App Store apps and VSCode extensions.
- _An Ansible roles directory_, which for now at least, only includes a [macos role](https://github.com/MurtadhaInit/macos-ansible-setup) in the form of yet another Git submodule.
  - This is responsible for orchestrating the setup of my main Mac machine with various Ansible tasks.
- _A Bash script_ responsible for bootstrapping the setup by first making sure Python is available, then installing Ansible in a venv, and finally running the playbook.

## How to use this workflow

Run the following command in a terminal on the target machine (or through SSH):

```shell
curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash && $HOME/ansible-temp/ansible-setup/bin/ansible-playbook ~/.dotfiles/local.yml --ask-become-pass --ask-vault-pass --skip-tags all_apps
```

> Note: this workflow assumes the existence of a Python installation, bash, and Git on the target machine.

## What this workflow does to your Mac and how

1. The bootstrap script does the following in order: it makes sure Python 3 is installed, it creates the directory `~/ansible-temp`, it installs pip3 if missing and upgrades it, it installs `virtualenv` and `setuptools`, it creates a virtualenv in that directory and it installs Ansible within it, and finally if `~/.dotfiles` doesn't exist, it will clone this repository in that location.
2. After that, the single command you used to pull this bootstrap file and run it will then use Ansible from that temporary location to run the relevant playbook depending on the type of operating system.
3. The MacOS playbook include tasks that achieve the following: install Homebrew, install and setup ZSH and make it the default shell, install essential CLI apps and tools, apply my dotfiles, configure various tools, optionally install all other apps (which requires an App Store login), and finally install the latest versions of Python (with pyenv), Node (with fnm), or any other languages or runtimes required. For more details, check out the [MacOS role](https://github.com/MurtadhaInit/macos-ansible-setup) repository.

## Important

This entire workflow is still under development. It lacks stronger testing mechanisms and reproducibility is not guaranteed. There are also a few bugs and shortcomings that are yet to be ironed out. Use at your own risk!
