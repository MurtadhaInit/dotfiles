{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    jetbrains-toolbox
  ];

  xdg.configFile = {
    "ideavim/ideavimrc".source = ../../../../Applications/ideavim/.config/ideavim/ideavimrc;
  };
}
