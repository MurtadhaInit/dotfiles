{ config, pkgs, ... }:

{
  # Keyboard layout for the SDDM login screen and virtual consoles.
  # Despite the `xserver` name this is the standard NixOS layout option — it also feeds the
  # Wayland session via XKB_DEFAULT_* and doesn't require an X session.
  # NOTE: the desktop session's US+Arabic switching lives in the home-manager plasma module.
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  time.timeZone = "Asia/Amman";

  i18n = {
    defaultLocale = "en_GB.UTF-8";
    extraLocales = [ "ar_IQ.UTF-8/UTF-8" ];

    extraLocaleSettings = {

      LC_ADDRESS = "ar_JO.UTF-8";
      LC_IDENTIFICATION = "ar_JO.UTF-8";
      LC_MEASUREMENT = "ar_JO.UTF-8";
      LC_MONETARY = "ar_JO.UTF-8";
      LC_NAME = "ar_IQ.UTF-8";
      LC_NUMERIC = "en_GB.UTF-8";
      LC_PAPER = "ar_JO.UTF-8";
      LC_TELEPHONE = "ar_JO.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };
  };
}
