#!/usr/bin/env bash
#
# Set up a machine from this repo with one command:
#
#   curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash
#
# Idempotent, so it doubles as "re-apply everything". In order:
#   1. Install Nix (Determinate) if missing; on macOS also Homebrew, which supplies the
#      CLI tools home-manager defers to there
#   2. Clone this repo to ~/.dotfiles, or update its submodules if already cloned
#   3. Activate the flake: nix-darwin + home-manager on macOS, home-manager on Linux,
#      nixos-rebuild on NixOS (home-manager is a NixOS module there)
#   4. macOS: install the Brewfile
#
# A fresh NixOS install starts from the live ISO with `nixos-install --flake` and this
# script takes over once the system boots.
# The Nushell tasks under system-setup/ are optional extras: run `dot` afterwards.

set -euo pipefail

REPO="https://github.com/MurtadhaInit/dotfiles.git"
DIR="$HOME/.dotfiles" # dotfiles.repoPath in the flake defaults to this path
FLAKE="$DIR/system-setup/nix"
# Lets the nix calls below work on a stock Nix install that has not opted into flakes
export NIX_CONFIG="extra-experimental-features = nix-command flakes"

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux) if [ -e /etc/NIXOS ]; then OS=nixos; else OS=linux; fi ;;
  *)
    echo "⚠️ Unsupported OS: $(uname -s)" >&2
    exit 1
    ;;
esac

exists() { command -v "$1" >/dev/null 2>&1; }
step() { printf '\n🔄 %s\n' "$*"; }
# Git may not exist yet on a fresh Linux box; Nix can lend it for the clone.
git_() { if exists git; then git "$@"; else nix shell nixpkgs#git -c git "$@"; fi; }

nix_profile=/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
if ! exists nix; then
  if [ ! -e "$nix_profile" ]; then
    step "Installing Nix"
    # Determinate on every host: same installer everywhere and flakes on by default. On
    # macOS its daemon is what darwin-modules/determinate.nix manages, and the
    # case-sensitive volume is what lets that module set use-case-hack = false.
    planner=""
    [ "$OS" = macos ] && planner="macos --case-sensitive"
    # shellcheck disable=SC2086 # $planner is deliberately word-split
    curl -fsSL https://install.determinate.systems/nix |
      sh -s -- install $planner --determinate --no-confirm
  fi
  # A fresh install only reaches new login shells
  # shellcheck disable=SC1090
  . "$nix_profile"
fi

if [ "$OS" = macos ]; then
  if [ ! -x /opt/homebrew/bin/brew ]; then
    step "Installing Homebrew"
    NONINTERACTIVE=1 /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi
  eval "$(/opt/homebrew/bin/brew shellenv)"
  brew analytics off
fi

if [ -d "$DIR/.git" ]; then
  step "Updating submodules in $DIR"
  git_ -C "$DIR" submodule update --init --recursive
else
  step "Cloning into $DIR"
  git_ clone --recursive "$REPO" "$DIR"
fi

# System activations are built from this repo's flake so nix-darwin and home-manager
# come from its flake.lock rather than whatever `nix run <tool>/master` resolves to.
hm=""
case "$OS" in
  macos)
    step "Activating nix-darwin (macbookpro)"
    system=$(nix build --no-link --print-out-paths "$FLAKE#darwinConfigurations.macbookpro.system")
    sudo "$system/sw/bin/darwin-rebuild" switch --flake "$FLAKE#macbookpro"
    hm=murtadha
    ;;
  linux) hm=murtadha@ubuntu-vm ;;
  nixos)
    step "Activating NixOS (nixos-workstation)"
    sudo nixos-rebuild switch --flake "$FLAKE#nixos-workstation"
    ;;
esac

if [ -n "$hm" ]; then
  step "Activating home-manager ($hm)"
  generation=$(nix build --no-link --print-out-paths "$FLAKE#homeConfigurations.\"$hm\".activationPackage")
  # Files already in place get moved aside instead of aborting the switch, which matters
  # on a distro that has already written its own ~/.config entries.
  HOME_MANAGER_BACKUP_EXT=hm-bkp "$generation/activate"
fi

if [ "$OS" = macos ]; then
  step "Installing the Brewfile"
  # App Store entries need an App Store sign-in first, so a partial failure is expected
  # on a fresh machine: sign in, then re-run this script or the command below.
  brew bundle install --no-upgrade --file="$DIR/Homebrew/Brewfile" ||
    echo "⚠️ Some Brewfile entries failed. Sign in to the App Store and re-run:
    brew bundle install --no-upgrade --file=$DIR/Homebrew/Brewfile"
fi

printf '\n🚀 Done!\n'
