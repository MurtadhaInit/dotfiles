{ pkgs, ... }:

# Onboard Realtek ALC887-VD (ASUS B350 board) audio fixes.
#
# The card reports BOTH analog output jacks as plugged in, whatever is actually connected:
#
#   analog-output-lineout     (rear green jack, the speakers)  prio 9000
#   analog-output-headphones  (front-panel header, unused)     prio 9900
#
# WirePlumber selects the highest-priority available output, so the phantom Headphones port
# wins — and selecting it mutes the rear line-out at the codec ("Front Playback Switch" off),
# playing audio out a jack with nothing in it. The choice is redone whenever the ALSA device is
# re-probed, most visibly on S3 resume, which is why sound died after every wake.
#
# Fix: hide the phantom Headphones port so it can never be selected (below). The amixer /
# power_save workarounds further down predate this diagnosis — they unmuted Front from outside
# PipeWire and lost the race against WirePlumber re-muting it — and are kept only as harmless
# belt-and-braces; likely removable once a few suspend cycles confirm the port fix holds alone.

let
  # Card index is assigned by probe order and moves across reboots, so resolve it from the stable
  # ALC887 codec rather than hard-coding it (else this could target e.g. the NVIDIA HDMI card).
  fixRealtekAudio = pkgs.writeShellScript "alsa-fix-realtek" ''
    card=$(${pkgs.gnugrep}/bin/grep -l ALC887 /proc/asound/card*/codec#* 2>/dev/null \
      | ${pkgs.gnused}/bin/sed -n 's:.*/card\([0-9]\+\)/.*:\1:p' \
      | ${pkgs.coreutils}/bin/head -n1)
    if [ -z "$card" ]; then
      echo "alsa-fix-realtek: Realtek ALC887 codec not found" >&2
      exit 1
    fi
    ${pkgs.alsa-utils}/bin/amixer -c "$card" set 'Auto-Mute Mode' Disabled
    ${pkgs.alsa-utils}/bin/amixer -c "$card" set Front unmute
  '';
in
{
  # The fix (see header). Matched on the stable PCI address, which also sidesteps the NVIDIA HDMI
  # codec's identically-named port. Drop this if the front-panel header is ever actually used.
  services.pipewire.wireplumber.extraConfig."51-alsa-hide-phantom-headphones" = {
    "monitor.alsa.rules" = [
      {
        matches = [ { "device.name" = "alsa_card.pci-0000_0a_00.3"; } ];
        actions.update-props."api.acp.hidden-ports" = [ "analog-output-headphones" ];
      }
    ];
  };

  # ---- Legacy belt-and-braces (see header); probably redundant now ----

  # Keep the codec in D0 instead of powering down to D3 after ~10s of silence: each D3->D0 cycle
  # re-inits the codec and can re-mute Front. Costs a little idle power.
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  # Re-assert sane mixer defaults at login. Ordered after WirePlumber, with a delay, because
  # WirePlumber reconfigures the ALSA controls asynchronously after its unit reports started.
  systemd.user.services.alsa-fix-realtek = {
    description = "Fix ALSA defaults for Realtek ALC887-VD at login";
    after = [ "wireplumber.service" ];
    wantedBy = [ "default.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 5";
      ExecStart = "${fixRealtekAudio}";
    };
  };

  # And again on resume: WantedBy/After the sleep targets so it runs on wake, after a short delay
  # to let the codec finish re-initialising.
  systemd.services.alsa-fix-realtek-resume = {
    description = "Re-apply ALSA defaults for Realtek ALC887-VD after resume";
    after = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    wantedBy = [
      "suspend.target"
      "hibernate.target"
      "hybrid-sleep.target"
      "suspend-then-hibernate.target"
    ];
    serviceConfig = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${fixRealtekAudio}";
    };
  };
}
