{ config, pkgs, ... }:

{
  # Font packages
  fonts = {
    packages = with pkgs; [
      # atkinson-hyperlegible
      atkinson-hyperlegible-next
      atkinson-hyperlegible-mono
      nerd-fonts.symbols-only
    ];
    # Install a few "basic" fonts for reasonable Unicode coverage
    enableDefaultPackages = true;
  };

  # Custom fonts
  # TODO
}
