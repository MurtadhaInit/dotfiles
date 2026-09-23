{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.zsh;

  # the Catppuccin themes repo for zsh-syntax-highlighting
  catppuccin-zsh-syntax-highlighting = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "zsh-syntax-highlighting";
    rev = "7926c3d3e17d26b3779851a2255b95ee650bd928";
    hash = "sha256-l6tztApzYpQ2/CiKuLBf8vI2imM6vPJuFdNDSEi7T/o=";
  };

  # Plugins are pinned by Nix instead of a plugin manager (or Homebrew).
  # Each is symlinked into $XDG_DATA_HOME/zsh/plugins/<name>, a stable path .zshrc sources.
  plugins = {
    zsh-autosuggestions = "${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions";
    zsh-syntax-highlighting = "${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting";
    catppuccin-theme = "${catppuccin-zsh-syntax-highlighting}/themes/catppuccin_mocha-zsh-syntax-highlighting.zsh";
  };
in
{
  options.dotfiles.zsh = {
    enable = lib.mkEnableOption "ZSH with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    # Install zsh directly rather than via programs.zsh: the latter generates its own
    # startup files, which would collide with the hand-written ones linked below.
    home.packages = lib.mkIf cfg.installPackage [ pkgs.zsh ];

    home.file = {
      ".zshenv".source = ../../../Applications/zsh/.zshenv;
      ".zprofile".source = ../../../Applications/zsh/.zprofile;
      ".zshrc".source = ../../../Applications/zsh/.zshrc;
    };

    xdg.dataFile = {
      "zsh/plugins/zsh-autosuggestions".source = plugins.zsh-autosuggestions;
      "zsh/plugins/zsh-syntax-highlighting".source = plugins.zsh-syntax-highlighting;
      "zsh/plugins/catppuccin_mocha-zsh-syntax-highlighting.zsh".source = plugins.catppuccin-theme;
    };
  };
}
