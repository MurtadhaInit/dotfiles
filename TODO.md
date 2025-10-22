# Things to perform on macOS once Nix is adopted (nix-darwin)

1. Configure Nushell tools to generate their respective configs whenever they are updated (carapace, atuin, starship, and zoxide). See setup-nushell.nu
2. Remove the Catppuccin theme file for Delta (in Applications, the git/delta directory) as this is now sourced from the git repo for Catppuccin for Delta.
3. Adjust the fetchFromGithub in all home-manager config files to pull the repos through flake inputs instead (the current setup pins to a particular commit through the hash).
4. See if the SSH config still requires any other improvements or changes.
5. Research and understand further the use of agenix and the setup config created for fonts.
6. Remove the shared Nushell task for setting up XDG_ en vars for macOS. This is not needed anymore as I've decided to let Nushell use the default (inconvenient) location for config.
7. Fix the issue of apps being installed twice on macOS (through Homebrew, originally, and then now through Nix when using the same existing modules). Nushell is one such example: `which nu` will show both, but only the Homebrew one is made the default and added to the list of shells.
8. Rename the folder modules/user to modules/home-manager for better clarity. Or, move and rename both directories: ./hm-modules and ./nixos-modules instead of modules/user...etc.
9. Consider adding a default.nix to each user and system directories to define the submodules to be imported and/or enabled by default. We can then add an import at the directory level (which will import `default.nix`). We can then enable or disable individual submodules.
10. Organise modules by purpose in a subdirectory. E.g. modules/system/services and modules/system/programs
