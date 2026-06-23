{ config, ... }:

{
  # Tailscale as a regular client.
  # Enabling the service also installs the `tailscale` CLI into the system profile.
  # Unlike macOS/Windows (which accept advertised subnet routes automatically),
  # Linux ignores them unless told otherwise — so `--accept-routes` pulls in the
  # homelab subnet router's advertised LAN (10.20.30.0/24) and routes it through
  # tailscale, matching how the Mac already behaves.
  services.tailscale = {
    enable = true;
    openFirewall = true; # opens UDP port 41641 so peers can negotiate direct connections
    # Instead of extraUpFlags: applied via `tailscale set` on every activation and not gated
    # on an authkey, so it stays in sync with interactive `tailscale up`.
    extraSetFlags = [ "--accept-routes" ];
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

# After applying run with: sudo tailscale up --accept-routes --operator=murtadha
# --operator lets the regular user drive tailscaled (CLI + KDE tray apps) without sudo.
# TODO: once https://github.com/tailscale/tailscale/issues/18294 is fixed we can
# reliably add --operator to extraSetFlags instead.
