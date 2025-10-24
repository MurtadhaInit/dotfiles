{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    helix
  ];

  xdg.configFile = {
    "helix/config.toml".source = ../../../../Applications/helix/config.toml;
    "helix/languages.toml".source = ../../../../Applications/helix/languages.toml;
  };
}
