{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  options = {
    devbox.enable = lib.mkEnableOption "Install DevBox";
  };

  config = lib.mkIf config.devbox.enable {
    home.packages = [
      inputs.devbox.packages.${pkgs.system}.default
    ];
  };
}
