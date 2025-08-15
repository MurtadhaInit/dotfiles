{
  fileSystems."/run/media/murtadha/Files" = {
    device = "/dev/disk/by-uuid/4EF611C1F611A9EB";
    fsType = "ntfs3";
  };

  fileSystems."/run/media/murtadha/New Volume" = {
    device = "/dev/disk/by-uuid/008A4B1F8A4B1098";
    fsType = "ntfs3";
  };

  services.udisks2.enable = true;
  services.gvfs.enable = true;
}
