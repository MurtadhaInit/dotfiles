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
  imports = [ ../common.nix ];

  options.dotfiles.tuna = {
    enable = lib.mkEnableOption "Tuna with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      "Library/Application Support/Tuna/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/tuna/config.toml";
    };
  };
}
