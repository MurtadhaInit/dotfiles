{ ... }:

{
  imports = [
    ../../profiles/cli.nix
  ];

  # the user and their home path to be managed
  home.username = "murtadha";
  home.homeDirectory = "/home/murtadha";
  home.stateVersion = "26.11";
  programs.home-manager.enable = true; # let Home Manager install and manage itself

  # Not NixOS: teaches home-manager about the distro's own layout — XDG_DATA_DIRS
  # gains /usr/share and the Nix profile, and NIX_PATH/TERMINFO_DIRS get set for
  # systemd user services.
  targets.genericLinux.enable = true;
  # ...but that flag also switches on non-NixOS GPU driver integration by default,
  # which pulls a driver package and an activation-time probe. Nothing here renders.
  targets.genericLinux.gpu.enable = false;
}
