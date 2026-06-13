{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

let
  cfg = config.dotfiles.devbox;
in
{
  options.dotfiles.devbox = {
    enable = lib.mkEnableOption "Devbox with dotfiles defaults";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      inputs.devbox.packages.${pkgs.system}.default
    ];

    # Devbox can be used per-project: a project's devbox.json is activated via direnv
    # (`use devbox` in .envrc), which the nushell direnv hook already picks up.
    # No shell-startup integration is needed for that.
    #
    # The *global* devbox profile (`devbox global add ...`) is intentionally NOT
    # wired into the shell — global tools are handled by mise (and others) instead.
    # If you ever do want it in every nushell, add this block to nushell's config.nu:
    #   # DevBox global env (https://github.com/jetify-com/devbox/blob/main/NUSHELL.md)
    #   if (which devbox | is-not-empty) {
    #     devbox global shellenv --format nushell --preserve-path-stack -r
    #       | lines
    #       | parse "$env.{name} = \"{value}\""
    #       | where name != null
    #       | transpose -r
    #       | into record
    #       | load-env
    #     $env.PATH = $env.PATH | split row (char env_sep)
    #   }
    #
    # This is better than devbox's stock NUSHELL.md snippet:
    #   - guarded with `which devbox`, so a missing devbox doesn't error on every
    #     shell spawn;
    #   - converts PATH back to a list afterward, because devbox emits it as a
    #     colon-joined string which would otherwise break nushell command lookup.
    # (`-r` recomputes the env on every shell start; drop it to use devbox's cache
    # if startup feels slow.)
  };
}
