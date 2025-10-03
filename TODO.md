# Things to perform on macOS once Nix is adopted (nix-darwin)

1. Remove the eza theme file for catppuccin from ./Applications as this is linked from the cloned repo in home-manager config
2. Configure Nushell tools to generate their respective configs whenever they are updated (carapace, atuin, starship, and zoxide). See setup-nushell.nu
3. Remove the Catppuccin theme file for Delta (in Applications, the git/delta directory) as this is now sourced from the git repo for Catppuccin for Delta.
4. Adjust the fetchFromGithub in all home-manager config files to pull the repos through flake inputs instead (the current setup pins to a particular commit through the hash).
5. See if the SSH config still requires any other improvements or changes.
6. Research and understand further the use of agenix and the setup config created for fonts.
7. Remove the shared Nushell task for setting up XDG_ en vars for macOS. This is not needed anymore as I've decided to let Nushell use the default (inconvenient) location for config.
