{
  config,
  pkgs,
  lib,
  ...
}:

{
  # TODO: explore other configurations and consider maintaining the settings.json file here, version-controlled
  programs.vscode = {
    enable = lib.mkDefault true;
  };

  xdg.configFile = {
    "nvim-vscode" = {
      source = ../../../../Applications/nvim-vscode;
      recursive = true;
    };
  };
}
