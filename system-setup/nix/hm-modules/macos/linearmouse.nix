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
  imports = [ ../common.nix ];

  options.dotfiles.linearmouse = {
    enable = lib.mkEnableOption "Linearmouse with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."linearmouse/linearmouse.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/linearmouse/linearmouse.json";
  };
}
