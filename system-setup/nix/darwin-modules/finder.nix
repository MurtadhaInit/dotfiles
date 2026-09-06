{ ... }:

{
  system.defaults.finder = {
    ShowPathbar = true;
    ShowStatusBar = true;

    NewWindowTarget = "Home";
    FXDefaultSearchScope = "SCcf"; # search the current folder, not the whole Mac
    _FXSortFoldersFirst = true; # keep folders on top in windows when sorting by name
    FXEnableExtensionChangeWarning = false;
    FXRemoveOldTrashItems = true; # purge Trash items after 30 days

    ShowMountedServersOnDesktop = true;
  };

  system.defaults.CustomUserPreferences."com.apple.finder" = {
    WarnOnEmptyTrash = false;
    ShowRecentTags = false;
  };
}
