{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfiles.zed;
in
{
  options.dotfiles.zed = {
    enable = lib.mkEnableOption "Zed with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  # TODO: Make use of the default Zed home-manager module: https://mynixos.com/home-manager/options/programs.zed-editor
  config = lib.mkIf cfg.enable {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        zed-editor
      ]
    );

    xdg.configFile."zed/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dotfiles/Applications/zed/settings.json";
  };
}
