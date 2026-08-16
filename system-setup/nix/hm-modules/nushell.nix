{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.nushell;

  # the Catppuccin themes repo for Nushell
  catppuccin-nushell = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "nushell";
    rev = "815dfc6ea61f2746ff27b54ef425cfeb7b51dda8";
    hash = "sha256-124T2pCmwirl8eLAy3h1fDOQZJf//3KJ7GwIP+u6YQ4=";
  };

  # the actual Nushell theme files
  themes-dir = "${catppuccin-nushell}/themes/";
in
{
  options.dotfiles.nushell = {
    enable = lib.mkEnableOption "Nushell with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.nushell = {
      enable = true;
      package = lib.mkIf (!cfg.installPackage) null;
      configFile.source = ../../../Applications/nushell/config.nu;
    };

    # on macOS
    home.file = lib.mkIf pkgs.stdenv.isDarwin {
      "Library/Application Support/nushell/themes".source = themes-dir;
      "Library/Application Support/nushell/scripts" = {
        recursive = true;
        source = ../../../Applications/nushell/scripts;
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
        "nushell/config.nu".source = ../../../Applications/nushell/config.nu;
        "nushell/themes".source = themes-dir;
        "nushell/scripts" = {
          recursive = true;
          source = ../../../Applications/nushell/scripts;
        };
      })

      # Linux
      (lib.mkIf pkgs.stdenv.isLinux {
        "nushell/themes".source = themes-dir;
        "nushell/scripts" = {
          recursive = true;
          source = ../../../Applications/nushell/scripts;
        };
      })
    ];
  };
}
