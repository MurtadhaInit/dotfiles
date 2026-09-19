# Dotfiles & machine setup

## Overview and purpose

This repository keeps track of and declaratively defines (mostly through Nix) all the applications and tools to be installed on a number of different hosts. It contains the configurations, settings, and preferences for most of these tools and some of these systems. The aim is to be able to quickly bootstrap any such host with my identical setup and to do this both seemlessly and consistently across hosts.

These hosts currently include a macOS laptop, a NixOS desktop, and a generic headless Ubuntu VM running on my homelab. Depending on the host type, the setup and configuration may consist of any combination of NixOS modules, home-manager modules, nix-darwin modules, or a Homebrew Brewfile.

Additional ad-hoc tasks in the form of Nushell setup scripts can be ran manually, selectively, and repeatedly.

Hand-written app configs live in `Applications/<app>/`.

## Working agreements and conventions

- Don't Nix "switch" on your own, leave that to me.
- Nix modules should generally remain reusable and generic (applicable to various host types), with their declared options serving as the abstracted interface that can be configured per host.
- Secrets are opt-in per host — importing agenix commits that machine to holding the age identity, and a missing key fails the whole activation.

## Pitfalls

- When adding a new home-manager module, if the linked files can be updated from the GUI or if they are rewritten by the app at runtime, you have the option of using `mkOutOfStoreSymlink` with `config.dotfiles.repoPath`.
- Some apps rewrite through the symlink atomically (resolve one level, write a temp file alongside, rename). `home.file` always makes hop #1 the read-only store path, so that write hits EROFS even via `mkOutOfStoreSymlink`. Those need a direct `ln -sf` from a `home.activation` entry — e.g. `claude-code.nix`.
- Any home-manager `systemd.user.services.*` that reads an agenix secret at startup must order itself after the decryption unit: `Unit.After`/`Wants = [ "agenix.service" ]`, guarded by `lib.mkIf pkgs.stdenv.isLinux`. Without it the service loses a cold-boot race, its `ExecStartPre` fails on the missing secret, and dependent oneshots cascade-abort with `result 'dependency'` and never retry — looking like an unconfigured app. The race only fires on reboot, never on a warm switch. See `hm-modules/syncthing.nix`; verify with `journalctl --user -b -u agenix.service -u syncthing.service -o short-precise`.
