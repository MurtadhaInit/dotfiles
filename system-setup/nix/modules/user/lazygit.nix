{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    lazygit
  ];

  # TODO: might switch to the standalone theme file from Catppuccin
  xdg.configFile = {
    "lazygit/config.yml".source = ../../../../Applications/lazygit/.config/lazygit/config.yml;
  };
}
