{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.mise;
in
{
  options.dotfiles.mise = {
    enable = lib.mkEnableOption "Enable Mise with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        mise
      ]
    );

    xdg.configFile = {
      "mise/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/Applications/mise/config.toml";
    };
  };
}
