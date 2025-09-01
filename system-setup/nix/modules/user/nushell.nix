{ config, pkgs, ... }:

{
  programs.nushell = {
    enable = true;
    configFile.source = ../../../../Applications/nushell/.config/nushell/config.nu;
  };

  # install the themes
}
