{
  config,
  pkgs,
  lib,
  ...
}:

{
  options = {
    bun.enable = lib.mkEnableOption "Install and configure Bun";
  };

  config = lib.mkIf config.bun.enable {
    programs.bun = {
      enable = true;
    };
  };
}
