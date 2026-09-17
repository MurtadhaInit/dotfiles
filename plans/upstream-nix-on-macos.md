# Plan: upstream Nix on macOS via the NixOS installer fork

Status: planned, not applied. Do it on the next fresh Mac, or on the current one
together with a Nix reinstall. The Ubuntu VM already runs this way.

## Why

- One installer everywhere: [NixOS/nix-installer](https://github.com/NixOS/nix-installer)
  is the community fork of the Determinate installer (same receipt, same uninstaller)
  but installs upstream Nix. The VM's Ansible playbook already uses it.
- nix-darwin then manages Nix itself (daemon, `/etc/nix/nix.conf`, version via
  `flake.lock`) instead of deferring to `determinate-nixd`, so there is one less
  moving part and no FlakeHub-pinned input.
- Nothing Determinate-specific is relied on. Lost: the FlakeHub cache, lazy trees, and
  Determinate's built-in Linux builder (the LXC builder in `determinate.nix` covers
  that already).

## Constraints

- One config cannot serve both: `determinateNix.enable` requires Determinate Nix, and
  nix-darwin's own `nix.enable` requires it to own the daemon. So the config change
  and the reinstall land together.
- nix-darwin must be uninstalled *before* Nix, otherwise macOS networking breaks
  (documented nix-darwin quirk: its `/etc/hosts`/resolver changes outlive the store).
- The `/nix` volume must stay case-sensitive: `use-case-hack = false` in the config
  assumes it, and the fork's `macos` planner keeps the `--case-sensitive` flag.

## Config changes (one commit)

1. `flake.nix`: drop the `determinate` input.
2. `hosts/macos/darwin.nix`: drop `inputs.determinate.darwinModules.default`; rename
   the `determinate.nix` import to `nix.nix` (or fold into `host.nix`).
3. Replace `darwin-modules/determinate.nix` with nix-darwin's native options. Same
   builder schema, so it is a move rather than a rewrite:

   ```nix
   { ... }:
   {
     nix.settings = {
       experimental-features = [ "nix-command" "flakes" ];
       # /nix is a case-sensitive volume (installer flag); the default macOS
       # collision workaround mangles buildEnv symlink names otherwise
       use-case-hack = false;
       builders-use-substitutes = true;
       trusted-users = [ "root" "murtadha" ];
     };
     nix.distributedBuilds = true;
     nix.buildMachines = [ { /* unchanged from determinate.nix */ } ];
   }
   ```

   Keep the comment about the case-sensitive volume; drop the ones about
   `nix.custom.conf`.
4. `bootstrap.bash`: swap the installer and drop the Determinate comment.

   ```bash
   planner=""
   [ "$OS" = macos ] && planner="macos --case-sensitive"
   curl -sSfL https://artifacts.nixos.org/nix-installer |
     sh -s -- install $planner --enable-flakes --no-confirm
   ```

   `--enable-flakes` matters: unlike Determinate, the fork leaves flakes off by
   default. The `NIX_CONFIG` export in the script covers the build steps either way.
5. `Applications/nushell/config.nu`: consider putting `/run/current-system/sw/bin`
   ahead of the Nix default profile so the `nix` CLI matches the daemon nix-darwin
   runs. Not required; mixed versions are supported, it just avoids surprises.

Verify before reinstalling anything: `nix build .#darwinConfigurations.macbookpro.system`
must evaluate and build on the current machine.

## Reinstall on the current Mac

```sh
sudo darwin-uninstaller                       # nix-darwin first, see Constraints
/nix/nix-installer uninstall                  # removes Nix, the volume and the daemon
curl -sSfL https://raw.githubusercontent.com/MurtadhaInit/dotfiles/main/bootstrap.bash | bash
```

On the first `darwin-rebuild switch`, nix-darwin moves the installer's
`/etc/nix/nix.conf` to `nix.conf.before-nix-darwin` and takes over. The store is
refetched from cache.nixos.org; budget time for that.

On a fresh Mac only the last line applies.

## Afterwards

- Nix upgrades come from `flake.lock` through `darwin-rebuild`, not `nix upgrade-nix`.
- `/nix/receipt.json` and `/nix/nix-installer` still exist for a clean uninstall.
