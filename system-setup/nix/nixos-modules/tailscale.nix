{ config, ... }:

{
  # Tailscale as a regular client.
  # Enabling the service also installs the `tailscale` CLI into the system profile.
  #
  # Intentionally NOT accepting advertised subnet routes (the homelab's 10.20.30.0/24) on this host,
  # which is already the default on linux (unlike mac/windows) because `--accept-routes` installs
  # 10.20.30.0/24 into a higher-priority policy-routing table (52) pointing at tailscale0, so unicast
  # replies to LAN hosts leave via the tailnet with the wrong source IP. That silently broke LAN-local
  # discovery (e.g. the Mac's LocalSend app couldn't see this host).
  # The Mac needs --accept-routes because it roams off-LAN while this workstation is stationary (wired).
  services.tailscale = {
    enable = true;
    openFirewall = true; # opens UDP port 41641 so peers can negotiate direct connections
  };

  # Trust the tailnet interface so other tailnet devices can reach this
  # workstation (SSH, etc.) without the local firewall dropping the packets.
  # Remove this line for outbound-only use.
  networking.firewall.trustedInterfaces = [ config.services.tailscale.interfaceName ]; # = tailscale0

  # Force tailscaled to program its firewall rules through nftables directly rather
  # than the iptables-nft compatibility shim this host's firewall otherwise uses.
  # The NixOS wiki's "modern setup" and avoids the legacy iptables code path.
  systemd.services.tailscaled.serviceConfig.Environment = [
    "TS_DEBUG_FIREWALL_MODE=nftables"
  ];
}

# After applying run with: sudo tailscale up --operator=murtadha
# --operator lets the regular user drive tailscaled (CLI + KDE tray apps) without sudo.
# TODO: once https://github.com/tailscale/tailscale/issues/18294 is fixed, set --operator
# declaratively via services.tailscale.extraSetFlags instead of the manual `up` above.
