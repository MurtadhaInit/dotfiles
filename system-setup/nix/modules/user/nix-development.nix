{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    nixfmt-rfc-style # Nix formatter
    nil # Nix LSP
    nixd # Nix LSP
  ];
}
