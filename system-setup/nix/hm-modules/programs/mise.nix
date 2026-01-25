{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.mise;
in
{
  options = {
    programs.mise = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the Mise package via Nix.
          Set to false if you want to use Mise installed through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
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
