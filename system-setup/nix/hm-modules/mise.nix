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
      # NOTE: mkOutOfStoreSymlink requires the source path to be fixed and absolute
      # TODO: utilise the home manager built-in variable to point to the user's home directory
      # then combine with the location of dotfiles (or find a better solution/function)
      "mise/config.toml".source =
        config.lib.file.mkOutOfStoreSymlink "/Users/murtadha/.dotfiles/Applications/mise/config.toml";
    };
  };
}
