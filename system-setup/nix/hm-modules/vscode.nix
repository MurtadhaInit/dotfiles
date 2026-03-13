{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.vscode;
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
    # TODO: explore other configurations and consider maintaining the settings.json file here, version-controlled
    programs.vscode = {
      enable = lib.mkIf cfg.installPackage true;
    };

    xdg.configFile = {
      "nvim-vscode" = {
        source = ../../../Applications/nvim-vscode;
        recursive = true;
      };
    };
  };
}
