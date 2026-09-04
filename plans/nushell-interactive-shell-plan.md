# Plan: POSIX login shell + exec into Nushell

Status: idea, not adopted. Revisit if Nushell-as-login-shell ever causes friction.

## The idea

Keep the *account's* login shell as a POSIX shell (zsh/bash) and make interactive
sessions land in Nushell by `exec`-ing into it from the POSIX shell's rc file.
This is how many fish/nushell users run "exotic" shells: system tooling sees a
POSIX login shell; humans see Nushell.

## Why bother (the failure modes it prevents)

- `ssh host 'some command'` runs the command through the login shell — remote
  scripts written for POSIX syntax break under nu.
- Installers/tools that append to "the shell rc" or invoke `$SHELL -c '...'`
  with POSIX syntax (fnm, various curl|sh installers, some IDE terminals).
- `su - murtadha -c '...'`, cron-style entries, display-manager Xsession bits —
  anything that assumes sh-compatible login shell semantics.

Currently none of these have bitten (Nushell IS the login shell on both
machines). This plan is the escape hatch if one does.

## How (sketch)

1. Revert login shell to zsh:
   - NixOS: drop `shell = pkgs.nushell;` from the user definition in
     `system-setup/nix/hosts/desktop/default.nix` (falls back to bash), or set
     `pkgs.zsh`.
   - macOS: `chsh -s /bin/zsh` (or leave the stock zsh default).
2. At the END of `Applications/zsh/.config/zsh/.zshrc` add, guarded:

   ```zsh
   # Hand interactive sessions to Nushell. Guards:
   #  [[ -o interactive ]] - never hijack scripts or `zsh -c`
   #  $NU_STARTED         - no exec loop if nu itself spawns zsh
   #  $TERM != dumb       - leave editors/IDE tooling shells alone
   if [[ -o interactive ]] && [[ -z "$NU_STARTED" ]] && [[ "$TERM" != dumb ]]; then
     export NU_STARTED=1
     exec nu   # exec replaces zsh: one process, Ctrl-D exits the terminal
   fi
   ```

3. Decide `exec nu` vs plain `nu`: `exec` is cleaner (no zombie parent, exit
   works naturally); plain `nu` keeps zsh underneath as a fallback you drop
   into on `exit` — handy while trialling.

## Gotchas to check before adopting

- Environment: zsh's `.zshenv`/`.zprofile` run first and are inherited by nu —
  this is actually a feature (PATH/env comes from one place), but verify no
  duplication with `Applications/nushell/config.nu` env setup.
- tmux/sesh: tmux `default-command` may need to stay `nu` explicitly, else each
  pane pays the zsh-then-exec startup cost (small but measurable).
- Terminal emulators launching `nu` directly (Ghostty etc.) bypass this path —
  fine, but keep them consistent to avoid two different startup env chains.
- Prompt/starship: both shells init starship; ensure the zsh init is skipped
  when it's only a trampoline (put the exec block before zsh's starship init).

## Rollback

Delete the rc block; optionally restore `shell = pkgs.nushell` — both machines
already proved that configuration works.
