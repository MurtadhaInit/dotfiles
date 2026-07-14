{ ... }:

# KDE Plasma 6 + SDDM.
# NOTE: user-level Plasma config (plasma-manager) lives in a home-manager
# module - disable when switching DEs.
{
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment (also installs everyday KDE apps).
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;
}
