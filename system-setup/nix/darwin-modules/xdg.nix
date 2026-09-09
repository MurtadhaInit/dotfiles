# Seed the XDG_* env vars into the user's launchd session at login.
# This is early enough that Nushell can correctly pick up its config location in
# ~/.config/nushell (from $XDG_CONFIG_HOME) -- assuming we didn't already seed the
# config both there and in `~/Library/Application Support/nushell` (we do, with home-manager).
#
# NOTE: we already export the same set of env vars in config.nu (Nushell) and .zprofile (ZSH).
# Except the bin and runtime dirs are not in .zprofile.
{ config, lib, ... }:

let
  home = "/Users/${config.system.primaryUser}";

  vars = {
    XDG_CONFIG_HOME = "${home}/.config";
    XDG_CACHE_HOME = "${home}/.cache";
    XDG_DATA_HOME = "${home}/.local/share";
    XDG_STATE_HOME = "${home}/.local/state";
    XDG_RUNTIME_DIR = "${home}/.local/run";
    XDG_BIN_HOME = "${home}/.local/bin";
  };

  setenv = lib.concatStringsSep "; " (
    lib.mapAttrsToList (name: value: "/bin/launchctl setenv ${name} ${lib.escapeShellArg value}") vars
  );
in
{
  launchd.user.agents.xdg-vars = {
    # ProgramArguments directly rather than `script`, which nix-darwin wraps in a wait
    # for /nix to mount (pointless for an agent that only calls launchctl).
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        setenv
      ];
      RunAtLoad = true;
      KeepAlive = false; # One-shot: it exits as soon as the variables are set.
    };
  };
}
