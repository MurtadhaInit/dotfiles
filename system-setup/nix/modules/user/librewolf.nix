{ config, pkgs, ... }:

{
  programs.librewolf = {
    enable = true;
    settings = {
      "privacy.clearOnShutdown.history" = false;
      "privacy.clearOnShutdown.downloads" = false;
      # "privacy.clearOnShutdown.cookies" = false;

      # enable autoscroll (and disable pasting with middle mouse click)
      "middlemouse.paste" = false;
      "general.autoScroll" = true;
    };
  };
}
