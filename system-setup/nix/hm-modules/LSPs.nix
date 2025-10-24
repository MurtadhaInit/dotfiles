{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    # Just
    just-lsp

    # Terraform
    terraform-ls

    # Nix
    nixfmt-rfc-style # Nix formatter
    nil # Nix LSP
    nixd # Nix LSP (better)
  ];
}
