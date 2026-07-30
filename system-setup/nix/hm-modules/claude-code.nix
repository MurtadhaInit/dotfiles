{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.dotfiles.claude-code;
  claudeDir = "${config.home.homeDirectory}/.dotfiles/Applications/claude-code";
in
{
  options.dotfiles.claude-code = {
    enable = lib.mkEnableOption "Claude Code config (settings + status line)";
  };

  # NOTE: Claude Code itself is installed through Mise
  config = lib.mkIf cfg.enable {
    # jq is required by the status line script (statusline-command.sh) to parse
    # Claude Code's JSON input.
    home.packages = [ pkgs.jq ];

    home.file.".claude/statusline-command.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${claudeDir}/statusline-command.sh";

    # Claude saves it atomically: it resolves the symlink ONE level, writes a temp
    # file next to the resolved target, then renames onto it. `home.file` always makes
    # hop #1 the read-only home-manager /nix/store path, so that temp write hits
    # EROFS (even via mkOutOfStoreSymlink, since the store hop is still first).
    # A DIRECT symlink resolves straight to the writable dotfiles file and hence avoids
    # the store indirection of `home.file`.
    home.activation.claudeSettings = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run mkdir -p "$HOME/.claude"
      run ln -sf ${claudeDir}/settings.json "$HOME/.claude/settings.json"
    '';
  };
}
