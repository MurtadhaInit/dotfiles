# Shells under nix-darwin

**Current state:** `programs.zsh.enable` and `programs.bash.enable` are both `false`
in `system-setup/nix/darwin-modules/shells.nix`. nix-darwin touches no shell file.

Both modules default to **enabled** upstream, so this is a deliberate opt-out, not
the absence of a decision.

## What the modules take over

| File | Current content | If the modules were enabled |
|---|---|---|
| `/etc/zshenv` | Hand-added `export ZDOTDIR="$HOME/.config/zsh"` + Determinate's SSH-only nix block | Hash unrecognised → **activation aborts** until renamed. Replacement sets no `ZDOTDIR` |
| `/etc/bashrc` | Determinate's nix block (macOS 26 variant) | Hash unrecognised → **activation aborts** until renamed |
| `/etc/zprofile` | Stock macOS (`path_helper`) | Hash known → replaced silently. **Loses the `path_helper` call** |
| `/etc/zshrc` | Determinate installer | Hash known → replaced silently. Its `nix-daemon.sh` block is replaced by nix-darwin's equivalent `setEnvironment`; no loss |

nix-darwin refuses to overwrite an `/etc` file whose SHA-256 it does not recognise,
so the two aborts are a safety net rather than a fault.

## What enabling them would cost

1. **Rename first:** `/etc/zshenv` and `/etc/bashrc` → `*.before-nix-darwin`.
2. **Re-declare ZDOTDIR** through `programs.zsh.shellInit`, which nix-darwin splices
   into the `/etc/zshenv` it generates.
3. **`path_helper` goes away.** PATH comes from a fixed `environment.systemPath`:
   ```
   $HOME/.nix-profile/bin:/run/current-system/sw/bin:/nix/var/nix/profiles/default/bin
   :/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin
   ```
   Dropped in zsh: all four `/etc/paths.d` entries (`10-cryptex`, `10-pmk-global`,
   `100-rvictl`, `Wireshark`) and `/System/Cryptexes/App/usr/bin`. Re-add through
   `environment.systemPath` if any of them are wanted.
4. **New exports** from the generated `/etc/zshenv`: `EDITOR=nano`, `PAGER='less -R'`,
   `XDG_CONFIG_DIRS`, `XDG_DATA_DIRS`, `NIX_PROFILES`, `NIX_USER_PROFILE_DIR`.
   `~/.config/zsh/.zprofile` sets the XDG ones afterwards and wins.

## Nushell is unaffected, and gains nothing

Nushell is the login shell (`chsh`), so **no zsh or bash startup file runs for a login
session at all**. That is why `ZDOTDIR` is invisible from nushell, and why
`Applications/nushell/config.nu` already reimplements for itself:

- `path_helper` (`$system_paths`, read from `/etc/paths` + `/etc/paths.d`)
- Determinate's profile setup (`NIX_PROFILES`, `NIX_SSL_CERT_FILE`, profile bin dirs)
- `/run/current-system/sw/bin`, where `darwin-rebuild` lives

Enabling `programs.zsh` changes none of that — the `config.nu` block stays required
either way. Its guard is evaluated once at shell startup, so a newly activated
generation only reaches shells started after it.

## When the zsh config gets sorted out

Two directions, whenever that task comes up:

- **Keep ZDOTDIR** — declare it via `programs.zsh.shellInit` and accept the costs above.
- **Drop it** — move `~/.config/zsh/*` to `$HOME`. Note it is load-bearing until then:
  `.zprofile` and `.zshrc` both `source "$ZDOTDIR/…"` for `vars.zsh`, `tools.zsh`,
  `aliases.zsh`, `functions.zsh` and `keybinds.zsh`.

The zsh dotfiles are still not Home Manager managed either way — see `TODO.md` item 8.
