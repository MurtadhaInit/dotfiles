{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.bat;
  # TODO: add an option for Homebrew to build the cache using the HB package

  # the Catppuccin themes repo for Bat
  catppuccin-bat = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "bat";
    rev = "main";
    hash = "sha256-lJapSgRVENTrbmpVyn+UQabC9fpV1G1e+CdlJ090uvg=";
  };

  # the actual Bat theme files
  themes-dir = "${catppuccin-bat}/themes/";
in
{
  options = {
    programs.bat = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install bat + bat-extras packages via Nix.
          Set to false if you want to install them through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    home.packages = lib.mkIf cfg.installPackage (
      with pkgs;
      [
        bat
        bat-extras.core
      ]
    );

    xdg.configFile = {
      "bat/config".source = ../../../../Applications/bat/config;

      # which is also $"(bat --config-dir)/themes"
      "bat/themes" = {
        source = themes-dir;
        onChange = lib.mkIf cfg.installPackage "${pkgs.bat}/bin/bat cache --build";
      };
    };
  };
}
