# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that automates a macOS or a Linux development machine setup using Nushell scripts or Ansible and manages configuration files for various development tools.

## Architecture

### Core Components

1. **Bootstrap Script** (`bootstrap.bash`): Entry point that installs prerequisites (Git, Homebrew, Nushell) and clones the repository
2. **Setup System** (`system-setup/`): Nushell-based task orchestration with OS detection and interactive/programmatic task selection. Nushell documentation is available at: <https://www.nushell.sh/book/>
3. **Dotfiles Management** (`Applications/`): Application configuration files managed via GNU Stow symlinks
4. **Package Management** (`Homebrew/Brewfile`): Declarative package list for CLI tools, GUI apps, and App Store apps

### Directory Structure

- `Applications/`: Dotfiles organized by application (zsh, nvim, git, etc.) - symlinked to `~/.config/`
- `system-setup/macos-tasks/`: Individual Nushell scripts for specific setup tasks
- `system-setup/utils/`: Shared utilities for task scripts
- `Homebrew/Brewfile`: Complete package manifest (424+ packages including VSCode extensions)

### Task System

Tasks in `system-setup/macos-tasks/` use priority comments (`# priority: N`) for execution order. The setup script (`setup.nu`) supports:

- Interactive task selection
- Programmatic skipping via `--skip-tasks`
- Full automation via `--all`
- Individual task execution

## Common Commands

### Initial Setup

```bash
# Full automated setup from scratch
curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/refs/heads/main/bootstrap.bash | bash

# Manual setup with task selection
./system-setup/setup.nu

# Skip specific tasks
./system-setup/setup.nu --skip-tasks ["all-apps", "macos-settings"]
```

### Maintenance Commands

```bash
# Update Brewfile packages
cd ~/.dotfiles/Homebrew && brew bundle install --cleanup --verbose

# Re-symlink dotfiles
cd ~/.dotfiles/Applications && stow --restow */

# Run individual setup tasks
nu ~/.dotfiles/system-setup/macos-tasks/[task-name].nu
```

### Git Operations

The repository uses submodules (nvim configuration). When making changes:

```bash
# Update submodules
git submodule update --remote --merge

# Commit with submodule changes
git add . && git commit -m "Update dotfiles and submodules"
```

## Key Development Tools

- **Shell**: ZSH with custom configuration in `~/.config/zsh`
- **Editor**: NeoVim (submodule) with extensive configuration
- **Terminal**: Multiple options (Ghostty, WezTerm, iTerm2)
- **Package Managers**: Homebrew, fnm (Node), pyenv (Python), gobrew (Go)
- **Development**: Docker (OrbStack), Git, GitHub CLI, various language tooling

## Testing Changes

The repository is designed to be idempotent - scripts check for existing installations before proceeding. To test changes:

1. Run specific task scripts individually: `nu system-setup/macos-tasks/[task].nu`
2. Use `--skip` flag for interactive testing of setup flow
3. VM testing recommended for full setup validation

## Ansible Integration

Recent Ansible usage creates a `.ansible/` directory for collections and modules. This is normal behavior and can be relocated by setting `ANSIBLE_HOME` environment variable if needed.
