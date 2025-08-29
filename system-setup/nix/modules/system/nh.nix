{ config, pkgs, ... }:

{
  programs.nh = {
    enable = true;
    # The absolute path to be used for the NH_FLAKE environment variable (default flake for nh operations)
    flake = "/home/murtadha/.dotfiles/system-setup/nix";

    # this is performed weekly by default
    clean = {
      enable = true;
      extraArgs = "--keep 10 --keep-since 7d";
    };
  };
}
