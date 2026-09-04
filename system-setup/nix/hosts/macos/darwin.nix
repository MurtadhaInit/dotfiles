{ inputs, ... }:

{
  imports = [
    inputs.determinate.darwinModules.default

    ../../darwin-modules/determinate.nix
    ../../darwin-modules/shells.nix
    ../../darwin-modules/keyboard.nix
    ../../darwin-modules/sudo.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  # Activation runs as root, so the options that write into a user's preference
  # domain (everything under system.defaults) need to be told whose.
  system.primaryUser = "murtadha";

  # ONLY bump up on fresh installs!
  system.stateVersion = 7;
}
