{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.linearmouse;
in
{
  options.dotfiles.linearmouse = {
    enable = lib.mkEnableOption "Enable Librewolf with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."linearmouse/linearmouse.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/Applications/linearmouse/linearmouse.json";
  };
}
