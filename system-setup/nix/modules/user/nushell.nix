{
  config,
  pkgs,
  lib,
  ...
}:

let
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
  programs.nushell = {
    enable = true;
    configFile.source = ../../../../Applications/nushell/Library
    + "/Application Support/nushell/config.nu";
  };

  # on macOS
  home.file = lib.mkIf pkgs.stdenv.isDarwin {
    "Library/Application Support/nushell/themes".source = themes-dir;
    "Library/Application Support/nushell/scripts" = {
      recursive = true;
      source = ../../../../Applications/nushell/Library + "/Application Support/nushell/scripts";
    };
  };

  # on Linux / additional macOS
  xdg.configFile = lib.mkMerge [
    # macOS: duplicate config files in the 2nd config dir
    (lib.mkIf pkgs.stdenv.isDarwin {
      /*
        NOTE: we link here too because our Nushell config will export XDG_ env vars.
        As a result, Nushell (though it uses the default macOS config location) will
        show an error message when running scripts for example: that XDG_CONFIG_HOME
        is set and yet there is no config file there.
      */
      "nushell/config.nu".source = ../../../../Applications/nushell/Library
      + "/Application Support/nushell/config.nu";
      "nushell/themes".source = themes-dir;
      "nushell/scripts" = {
        recursive = true;
        source = ../../../../Applications/nushell/Library + "/Application Support/nushell/scripts";
      };
    })

    # Linux
    (lib.mkIf pkgs.stdenv.isLinux {
      "nushell/themes".source = themes-dir;
      "nushell/scripts" = {
        recursive = true;
        source = ../../../../Applications/nushell/Library + "/Application Support/nushell/scripts";
      };
    })
  ];
}
