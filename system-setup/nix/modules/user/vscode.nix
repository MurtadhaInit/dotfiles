{ config, pkgs, ... }:

{
  # TODO: explore other configurations and consider maintaining the settings.json file here, version-controlled
  programs.vscode = {
    enable = true;
  };

  xdg.configFile = {
    "nvim-vscode" = {
      source = ../../../../Applications/nvim-vscode/.config/nvim-vscode;
      recursive = true;
    };
  };
}
