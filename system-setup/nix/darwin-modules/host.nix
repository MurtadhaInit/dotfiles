{ ... }:

{
  networking = {
    computerName = "macbookpro"; # friendly name: Sharing pane, AirDrop, Finder sidebar
    hostName = "macbookpro"; # the static UNIX hostname
    # NOTE: localHostName (Bonjour/mDNS) defaults to hostName in nix-darwin.
    # But macOS itself derives LocalHostName from ComputerName.
    #
    # When HostName is unset, macOS derives the hostname on every network change via
    # reverse-DNS lookup on the current IP, and falls back to LocalHostName + .local
    # if there's no PTR record.
  };

  # Silences the boot chime by writing nvram's StartupMute.
  system.startup.chime = false;
}
