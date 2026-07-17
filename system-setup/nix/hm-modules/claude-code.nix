{
  config,
  lib,
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

  # NOTE: installed through Mise
  config = lib.mkIf cfg.enable {
    home.file.".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${claudeDir}/settings.json";

    home.file.".claude/statusline-command.sh".source =
      config.lib.file.mkOutOfStoreSymlink "${claudeDir}/statusline-command.sh";
  };
}
