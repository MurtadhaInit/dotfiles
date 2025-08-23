{ config, pkgs, ... }:

{
  # Encrypted SSD
  boot.initrd.luks.devices."luks-f8bb3e60-c4ed-4046-b493-da44bffd2882".device =
    "/dev/disk/by-uuid/f8bb3e60-c4ed-4046-b493-da44bffd2882";

  # Because internal HDDs were formatted as ntfs
  boot.supportedFilesystems = [ "ntfs" ];

  # Automatically mount internal HDDs
  fileSystems."/run/media/murtadha/Files" = {
    device = "/dev/disk/by-uuid/4EF611C1F611A9EB";
    fsType = "ntfs-3g";
    options = [
      "defaults"
      "nofail"
      "uid=1000"
      "gid=100"
    ];
  };
  fileSystems."/run/media/murtadha/New Volume" = {
    device = "/dev/disk/by-uuid/008A4B1F8A4B1098";
    fsType = "ntfs-3g";
    options = [
      "defaults"
      "nofail"
      "uid=1000"
      "gid=100"
    ];
  };
}
