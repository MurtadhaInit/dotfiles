{ config, pkgs, ... }:

{
  # Font packages
  fonts.packages = with pkgs; [
    # atkinson-hyperlegible
    atkinson-hyperlegible-next
    atkinson-hyperlegible-mono
    nerd-fonts.symbols-only
  ];
  fonts.enableDefaultPackages = true; # causes some "basic" fonts to be installed for reasonable Unicode coverage

  # Custom fonts
  # TODO
}
