# Dotfiles & Development Machine Setup

This is my IaC workflow for automating and bootstrapping the full setup of my main development machine using Ansible.

## What is included

- _All my dotfiles_: the configuration files used for apps and CLI tools I regularly use.
  - Among those is my [NeoVim config](https://github.com/MurtadhaInit/nvim) as a Git submodule.
- _Brewfile_: this stores a list of every GUI and CLI app I'm currently using on my MacOS machine, as well as App Store apps and VSCode extensions.
- _An Ansible roles directory_: which for now at least, only includes a [macos role](https://github.com/MurtadhaInit/macos-ansible-setup) as a Git submodule.
  - This defines the steps needed to setup my main MacOS machine.
- _A `bootstrap.bash` script_: responsible for bootstrapping the setup process.
  - This is done by first making sure Python is available, then installing Ansible in a virtual environment, cloning this repository if not present, and finally running the playbook.

## How to use this workflow

Run the following command in a terminal on the target machine directly (or through SSH):

```shell
curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash && $HOME/ansible-temp/ansible-setup/bin/ansible-playbook ~/.dotfiles/local.yml --ask-become-pass --ask-vault-pass --skip-tags all_apps
```

> Note: this workflow assumes the availability of Python, Bash, and Git on the target machine.

## What this workflow does

1. The bootstrap script does the following in order:
   - it makes sure Python 3 is installed
   - it creates the directory `~/ansible-temp`
   - it installs pip3 if missing and upgrades it
   - it installs `virtualenv` and `setuptools`
   - it creates a virtualenv in that directory and it installs Ansible within it
   - and finally if `~/.dotfiles` doesn't exist, it will clone this repository in that location.
2. The command you used to pull this bootstrap file and run it will then use Ansible from that temporary location to run the relevant playbook depending on the type of operating system.
3. The MacOS playbook includes tasks that achieve the following:
   - install Homebrew
   - install and setup ZSH and make it the default shell
   - install essential CLI apps and tools
   - apply my dotfiles
   - configure different tools (like language version managers)
   - optionally install all other apps (requires being already signed in to the App Store)
   - and finally install the latest versions of Python, Node, and others.
   - For more details, check out the [MacOS role](https://github.com/MurtadhaInit/macos-ansible-setup) repository.

## Important Disclaimer

This entire workflow is still under development. It lacks proper testing, and reproducibility is not guaranteed. There are also a few bugs and shortcomings that are yet to be ironed out.

Use at your own risk!
