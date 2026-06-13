{ ... }:

{
  # Two internal NTFS data HDDs, shared with Windows (boot-menu dual-boot, so the
  # two OSes never touch the disks at the same time). Mounted with the in-kernel
  # ntfs3 driver — faster and lower-overhead than ntfs-3g (FUSE), and solid on a
  # recent kernel. To fall back to ntfs-3g: set fsType = "ntfs-3g" and add
  # `boot.supportedFilesystems = [ "ntfs" ];` (and drop the windows_names option).
  #
  # NOTE (dual-boot): if Windows ever leaves a volume dirty (Fast Startup is off,
  # so this should be rare), ntfs3 mounts it read-only instead of risking
  # corruption — do NOT add `force` to override that.
  fileSystems."/run/media/murtadha/Files" = {
    device = "/dev/disk/by-uuid/4EF611C1F611A9EB";
    fsType = "ntfs3";
    options = [
      "defaults"
      "nofail"
      "uid=1000"
      "gid=100"
      "umask=022"
      "windows_names"
    ];
  };
  fileSystems."/run/media/murtadha/New Volume" = {
    device = "/dev/disk/by-uuid/008A4B1F8A4B1098";
    fsType = "ntfs3";
    options = [
      "defaults"
      "nofail"
      "uid=1000"
      "gid=100"
      "umask=022"
      "windows_names"
    ];
  };
}
