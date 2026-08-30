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
  imports = [ ./common.nix ];

  options.dotfiles.mise = {
    enable = lib.mkEnableOption "Mise with dotfiles defaults";
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
        config.lib.file.mkOutOfStoreSymlink "${config.dotfiles.repoPath}/Applications/mise/config.toml";
    };
  };
}
