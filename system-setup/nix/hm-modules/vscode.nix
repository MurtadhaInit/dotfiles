{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.vscode;
  userDir =
    if pkgs.stdenv.isDarwin then "Library/Application Support/Code/User" else ".config/Code/User";
  vscodeDotfiles = "${config.home.homeDirectory}/.dotfiles/Applications/vscode";
in
{
  options.dotfiles.vscode = {
    enable = lib.mkEnableOption "Visual Studio Code with dotfiles defaults";
    installPackage = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Install the package via Nix (vs. just configure it)";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.vscode = {
      enable = lib.mkIf cfg.installPackage true;
    };

    # Extensions are handled separately by setup-vscode.nu, which syncs from
    # Applications/vscode/extensions.list
    home.file = {
      "${userDir}/settings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${vscodeDotfiles}/settings.json";
      "${userDir}/keybindings.json".source =
        config.lib.file.mkOutOfStoreSymlink "${vscodeDotfiles}/keybindings.json";
    };

    xdg.configFile = {
      "nvim-vscode" = {
        source = ../../../Applications/nvim-vscode;
        recursive = true;
      };
    };
  };
}
