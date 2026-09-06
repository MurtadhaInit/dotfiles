# macOS ships the application firewall off; turn it on but keep the default posture
# of letting signed software listen, so nothing needs approving after a reinstall.
{ ... }:

{
  networking.applicationFirewall = {
    enable = true;
    allowSigned = true; # allow built-in software to receive incoming connections
    allowSignedApp = true; # allow signed software to receive incoming connections
    enableStealthMode = false; # true = don't respond or acknowledge ICMP (e.g. Ping)
    blockAllIncoming = false;
  };
}
