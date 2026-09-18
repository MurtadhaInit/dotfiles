# Plan: declarative disks (disko) and remote installs (nixos-anywhere)

Status: idea, not adopted. Worth doing before the next desktop reinstall, or when a
second NixOS host appears.

## The gap today

Partitioning is the one step of a NixOS install that nothing in this repo describes.
`hardware-configuration.nix` and `storage.nix` carry partition UUIDs that only exist
after formatting by hand, so a reinstall means: partition manually, regenerate the
hardware config, fix the UUIDs, then `nixos-install`. Everything after that is
declarative already.

## disko

[disko](https://github.com/nix-community/disko) is a NixOS module plus a CLI. The
module turns a disk description into `fileSystems`, `swapDevices` and
`boot.initrd.luks.devices`. The CLI formats disks from that same description, but only
when invoked explicitly: a normal `nixos-rebuild switch` never touches a disk.

### What changes

1. Add the input and module:

   ```nix
   disko = {
     url = "github:nix-community/disko/latest";
     inputs.nixpkgs.follows = "nixpkgs";
   };
   ```

   and `inputs.disko.nixosModules.disko` in `hosts/desktop/default.nix`.

2. Write `hosts/desktop/hardware/disko.nix` describing the NVMe only. Address the disk
   by `/dev/disk/by-id/...` (stable across reinstalls, unlike UUIDs). Sketch:

   ```nix
   { ... }:
   {
     disko.devices.disk.nvme = {
       type = "disk";
       device = "/dev/disk/by-id/nvme-<model>_<serial>";
       content = {
         type = "gpt";
         partitions = {
           esp = {
             size = "1G";
             type = "EF00";
             content = {
               type = "filesystem";
               format = "vfat";
               mountpoint = "/boot";
               mountOptions = [ "fmask=0077" "dmask=0077" ];
             };
           };
           root = {
             size = "100%";
             content = {
               type = "luks";
               name = "cryptroot";
               passwordFile = "/tmp/luks.key"; # only read at format time
               content = {
                 type = "filesystem";
                 format = "ext4";
                 mountpoint = "/";
               };
             };
           };
           swap = {
             size = "<match current>";
             content = {
               type = "luks";
               name = "cryptswap";
               passwordFile = "/tmp/luks.key";
               content.type = "swap";
             };
           };
         };
       };
     };
   }
   ```

   Partition sizes and order must mirror the current layout if the goal is a no-op
   migration on the running machine (see below).

3. Keep the two NTFS data drives out of disko. It cannot describe a disk without
   owning it, and those are shared with Windows. Their `fileSystems` entries stay in
   `storage.nix`; the LUKS swap line there moves into disko.

4. Reduce `hardware-configuration.nix` to what disko does not generate: kernel modules,
   `kvm-amd`, microcode, `hostPlatform`. It stops needing regeneration after a
   reinstall.

### Migrating the running desktop

The point of the migration is that the description matches reality, so a later
`disko` format run reproduces exactly what exists.

1. Write `disko.nix` from `lsblk -o NAME,SIZE,FSTYPE,UUID,MOUNTPOINTS` and
   `ls -l /dev/disk/by-id`.
2. `nixos-rebuild build --flake .#nixos-workstation` and compare the generated
   `fileSystems`/`swapDevices`/luks entries with the current ones:
   `nix eval .#nixosConfigurations.nixos-workstation.config.fileSystems`.
   disko mounts by partition label or by-partlabel, so the by-uuid entries disappear
   and that is expected; what must match is device, fsType and options.
3. Switch. No disk is touched. If the machine boots, the migration is done.

Also verify the ESP is the NVMe's own and not shared with the Windows disk before
letting disko own it.

### Fresh install with disko

From the live ISO, one extra command before `nixos-install`:

```sh
echo -n '<passphrase>' > /tmp/luks.key
nix run github:nix-community/disko/latest -- \
  --mode destroy,format,mount --flake ~/.dotfiles/system-setup/nix#nixos-workstation
nixos-install --flake ~/.dotfiles/system-setup/nix#nixos-workstation
```

`destroy,format,mount` wipes the NVMe described in `disko.nix` and nothing else.

## nixos-anywhere

[nixos-anywhere](https://github.com/nix-community/nixos-anywhere) drives the whole
install over SSH from another machine: boots kexec into a NixOS installer if needed,
runs disko, installs the flake, reboots. It requires disko, which is why the two go
together.

From the Mac, with the desktop booted into the NixOS ISO (set a root password with
`passwd` and note the IP):

```sh
nix run github:nix-community/nixos-anywhere -- \
  --flake ~/.dotfiles/system-setup/nix#nixos-workstation \
  --disk-encryption-keys /tmp/luks.key ~/luks.key \
  --generate-hardware-config nixos-generate-config \
      ~/.dotfiles/system-setup/nix/hosts/desktop/hardware/hardware-configuration.nix \
  --build-on-remote \
  root@<ip>
```

- `--disk-encryption-keys` copies the passphrase file to the path `disko.nix` reads,
  so it never lives in the repo.
- `--build-on-remote` matters because the Mac is `aarch64-darwin` and the target is
  `x86_64-linux`. The LXC builder in the Nix config would also work without it.
- `--generate-hardware-config` writes the slimmed hardware file before the build, so
  step 4 above is not even a manual step.

After the reboot, the bootstrap one-liner finishes the job (repo clone to
`~/.dotfiles`, home-manager). The age identity still has to be present for the
secrets; see `plans/yubikey-age.md`.

## Cost

- ~60 lines of Nix and a careful one-time migration on the desktop.
- disko and nixos-anywhere are two more flake inputs.
- The Windows-shared drives stay hand-described, so the repo has two disk
  descriptions rather than one. Acceptable: those disks are never reformatted.
