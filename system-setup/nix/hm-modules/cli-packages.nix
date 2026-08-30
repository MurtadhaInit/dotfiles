# Essential CLI tools that need no configuration of their own.
{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.cli-packages;
in
{
  options.dotfiles.cli-packages = {
    enable = lib.mkEnableOption "essential CLI tools that require no configuration";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      age
      fd
      fzf
      gh
      lazydocker
      neovim
      ripgrep
      tlrc
      tree
      zoxide
    ];
  };
}
