# Settings shared across the dotfiles modules.
#
# Imported by the modules that need it rather than by the profiles, so a module stays
# self-contained when a host imports it directly.
{
  config,
  lib,
  ...
}:

{
  options.dotfiles.repoPath = lib.mkOption {
    type = lib.types.str;
    default = "${config.home.homeDirectory}/.dotfiles";
    description = ''
      Absolute path to this dotfiles checkout on the target machine.

      Only the modules placing out-of-store symlinks read this. Those links are
      resolved at runtime by the app rather than by Nix, so the repo has to actually
      live at this path or they dangle. Override it on a host that clones elsewhere.
    '';
  };
}
