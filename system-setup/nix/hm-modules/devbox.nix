{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.dotfiles.devbox;
in
{
  options.dotfiles.devbox = {
    enable = lib.mkEnableOption "Enable Devbox with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.devbox.packages.${pkgs.system}.default
    ];
  };
}
