{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.dotfiles.lsps;
in
{
  options.dotfiles.lsps = {
    enable = lib.mkEnableOption "Enable several LSPs with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # Just
      just-lsp

      # Terraform
      terraform-ls

      # Nix
      nixfmt # Nix formatter
      nil # Nix LSP
      nixd # Nix LSP (better)
    ];
  };
}
