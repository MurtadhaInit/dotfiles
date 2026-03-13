{
  config,
  lib,
  ...
}:

let
  cfg = config.dotfiles.bun;
in
{
  options.dotfiles.bun = {
    enable = lib.mkEnableOption "Bun with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    programs.bun = {
      enable = true;
    };
  };
}
