# Plan: YubiKeys as master recipients for agenix

Status: idea, not adopted. Solves the one manual secret in a fresh install: copying
`~/.ssh/keys/age.txt` to the new machine.

## The idea

Each host keeps its own software age key, as today, because home-manager decrypts
secrets non-interactively at activation (and at boot on NixOS). The two YubiKeys hold
one age identity each, in a PIV slot, and are added as recipients of every secret.
A YubiKey can then open everything, so a new host is enrolled by re-keying with a
touch instead of by moving a private key around. The second YubiKey is the backup.

Deliberately *not* the alternative of pointing `age.identityPaths` at a YubiKey: that
makes every activation need the key inserted and touched, cannot answer a PIN prompt
during the boot-time activation on NixOS, and needs a plugin-aware `age` wrapper in the
module. Fragile for no gain.

## Tooling

- [`age-plugin-yubikey`](https://github.com/str4d/age-plugin-yubikey): in nixpkgs and
  Homebrew. Uses PIV, which both the 5C NFC and the 5 NFC support. NFC is irrelevant
  here; both keys are used over USB.
- The plugin only has to exist where agenix runs (the Mac, mainly). Hosts that merely
  decrypt at activation stay plugin-free.
- `ykman` (nixpkgs `yubikey-manager`) for changing the PIV PIN and PUK from their
  factory defaults before generating anything.

## One-time setup

Per key, with the plugin on PATH:

```sh
age-plugin-yubikey --generate --name dotfiles \
  --pin-policy once --touch-policy cached
```

- `--pin-policy once`: PIN asked once per session, not per secret.
- `--touch-policy cached`: one touch covers about 15 seconds of operations, so a
  re-key of every secret is one or two touches rather than one per file.
- It picks a free "retired" PIV slot (82-95) and prints the recipient
  (`age1yubikey1...`) and the identity stub (`AGE-PLUGIN-YUBIKEY-...`).

The identity stub is not secret: it only tells the plugin which key and slot to use.
Commit both stubs, for example as `secrets/yubikey-5c.txt` and
`secrets/yubikey-5.txt`, so any machine with the plugin and a key can re-key.

Then in `secrets.nix`:

```nix
yubikey5c = "age1yubikey1...";
yubikey5 = "age1yubikey1...";
allHosts = [ macbook nixos-desktop yubikey5c yubikey5 ];
```

and re-key once with an existing host key, since that is what can decrypt today:

```sh
cd system-setup/nix/secrets
nix run github:ryantm/agenix -- -r -i ~/.ssh/keys/age.txt
```

Binary secrets (the fonts) re-key fine with `-r`; only `-e` would corrupt them.

## Enrolling a new host afterwards

On the new machine:

```sh
age-keygen -o ~/.ssh/keys/age.txt
age-keygen -y ~/.ssh/keys/age.txt   # public key for secrets.nix
```

On the Mac, with a YubiKey inserted:

```sh
cd system-setup/nix/secrets
nix run github:ryantm/agenix -- -r -i yubikey-5c.txt
```

Commit and pull on the new host, then rebuild. No private key crosses machines. The
README's "restore the age identity" step becomes "generate one and re-key".

## Losing a key

- One YubiKey lost: the other one and every host key can still decrypt. Remove the
  lost recipient from `secrets.nix`, re-key, and generate a replacement identity on
  a new key when it arrives.
- Both lost: no worse than today. Host keys still decrypt.

## Optional follow-ups

- Move SSH into the same keys via `ssh-keygen -t ed25519-sk` (FIDO2, resident) so the
  `ssh.nix` module can reference one key across hosts. Independent of age; not needed
  for this plan.
- Wrap the enrol steps into a Nushell task under `system-setup/tasks/` once done by hand at
  least once.
