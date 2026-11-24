{
  config,
  lib,
  inputs,
  ...
}:

let
  cfg = config.dotfiles.rex;
in
{
  imports = [ inputs.rex.homeManagerModules.default ];

  options.dotfiles.rex = {
    enable = lib.mkEnableOption "Rex with dotfiles defaults";

    # Linux only: on macOS the Rex app runs the server, and Rex's module rejects it (fails the build).
    linuxServer = lib.mkEnableOption ''
      a personal Rex server as a systemd user service named `rex`. It only survives
      logouts and starts at boot with lingering on (`loginctl enable-linger`)
    '';
  };

  config = lib.mkIf cfg.enable {
    # Installs `rex` (a single binary: both the server and the CLI that talks to it), writes
    # the `xterm-rex` terminfo entry to ~/.terminfo, and adds the SSH fallback to ~/.ssh/config.
    programs.rex.enable = true;

    # Runs a personal server as your account, in a systemd user service named `rex`.
    # Also turns on programs.rex.
    services.rex.enable = cfg.linuxServer;

    # The ssh fallback (TERM=xterm-256color for hosts lacking Rex's terminfo) only lands
    # in an ssh config home-manager writes. A no-op where dotfiles.ssh already enables it.
    programs.ssh = {
      enable = true;
      enableDefaultConfig = lib.mkDefault false;
    };
  };
}
