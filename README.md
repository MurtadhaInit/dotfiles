# Dotfiles & Development Machine Setup

This is my simple IaC solution for automating the full setup of my main development machine (only MacOS for now) using Nushell scripts.

## 🔧 How it works

Run the following command in a terminal on the target machine:

```shell
curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/refs/heads/main/bootstrap.bash | bash
```

> Note: the scripts are designed to be idempotent with checks in place, so running them again won't necessarily redo the defined tasks.

## 📋 What is included

- **Dotfiles**: configuration files for apps and CLI tools I regularly use.
  - Among those is my [NeoVim config](https://github.com/MurtadhaInit/nvim) as a Git submodule.
- **Brewfile**: a list of every GUI and CLI tool I'm currently using on my MacOS machine, as well as App Store apps and VSCode extensions.
- **Nushell scripts**: in the `system-setup` directory to automate setting up a new machine from scratch.

## ⚙️ What this workflow does

1. The bootstrap Bash script does the following in order:
    - Install Git, Homebrew (on MacOS), and nu if not present.
    - Clone this repository to `~/.dotfiles`.
    - Initiate the setup process by executing `start.nu`, passing in any provided arguments.
2. The start script will detect the operating system and execute the scripted tasks in the relevant directory in `system-setup`, skipping (or selecting) ones based on the arguments being passed either interactively or programmatically (if you fork the repo and edit the script).

## 🍎 MacOS Tasks

- Create the required directories
- Symlink all dotfiles using GNU Stow
- Setup ZSH
  - Install the latest version with Homebrew
  - Make it the default interactive shell for the current user
  - Switch the default location it looks for its configuration files to be `~/.config/zsh`
- Install a handful of CLI tools and application defined in a separate file using Homebrew
- Setup Node
  - Install `fnm`
  - Install the latest and the latest LTS versions of Node
- Setup Python
  - Install `pyenv`
  - Download the use the latest Python 3 version
- Setup `bat` (Install it and setup its themes)
- Setup `Warp` (Install it and setup its themes)
- Clone a defined set of repositories to their destinations
- Setup Go
  - Install `gobrew`
  - Install the latest version of Go
- Setup `tmux` (Installation and plugins)
- Use a `Brewfile` to install everything else (formulas, casks, and App Store apps) with Homebrew, which will require an Apple ID log in.
