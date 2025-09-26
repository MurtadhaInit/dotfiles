# Things to perform on macOS once Nix is adopted (nix-darwin)

1. Remove the eza theme file for catppuccin from ./Applications as this is linked from the cloned repo in home-manager config
2. Configure Nushell tools to generate their respective configs whenever they are updated (carapace, atuin, starship, and zoxide). See setup-nushell.nu
3. Remove the Catppuccin theme file for Delta (in Applications, the git/delta directory) as this is now sourced from the git repo for Catppuccin for Delta.
