{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.tuna;
in
{
  options.dotfiles.tuna = {
    enable = lib.mkEnableOption "Tuna with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      "Library/Application Support/Tuna/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/Applications/tuna/config.toml";
    };
  };
}
