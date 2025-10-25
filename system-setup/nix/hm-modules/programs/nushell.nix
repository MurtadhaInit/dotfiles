{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.programs.nushell;

  # the Catppuccin themes repo for Nushell
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "nushell";
    rev = "main";
    hash = "sha256-vaGiZHoGkHr1QcshO8abIQL/zIuw3hFcBhDYcKhOpNw=";
  };

  # the actual Nushell theme files
  themes-dir = "${catppuccin-nushell}/themes/";
in
{
  options = {
    programs.nushell = {
      installPackage = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = ''
          Whether to install the Nushell package via Nix.
          Set to false if you want to use Nushell installed through other means (e.g., Homebrew)
          while still managing the configuration through Home Manager.
        '';
      };
    };
  };

  config = {
    programs.nushell = {
      enable = true;
      package = lib.mkIf (!cfg.installPackage) null;
      configFile.source = ../../../../Applications/nushell/config.nu;
    };

    # on macOS
    home.file = lib.mkIf pkgs.stdenv.isDarwin {
      "Library/Application Support/nushell/themes".source = themes-dir;
      "Library/Application Support/nushell/scripts" = {
        recursive = true;
        source = ../../../../Applications/nushell/scripts;
      };
    };

    # on Linux / additional macOS
    xdg.configFile = lib.mkMerge [
      # macOS: duplicate config files in the 2nd config dir
      /*
        NOTE: we link here too because our Nushell config will export XDG_ env vars.
        As a result, Nushell (though it uses the default macOS config location) will
        show an error message when running scripts for example: that XDG_CONFIG_HOME
        is set and yet there is no config file there.
      */
      (lib.mkIf pkgs.stdenv.isDarwin {
        "nushell/config.nu".source = ../../../../Applications/nushell/config.nu;
        "nushell/themes".source = themes-dir;
        "nushell/scripts" = {
          recursive = true;
          source = ../../../../Applications/nushell/scripts;
        };
      })

      # Linux
      (lib.mkIf pkgs.stdenv.isLinux {
        "nushell/themes".source = themes-dir;
        "nushell/scripts" = {
          recursive = true;
          source = ../../../../Applications/nushell/scripts;
        };
      })
    ];
  };
}
