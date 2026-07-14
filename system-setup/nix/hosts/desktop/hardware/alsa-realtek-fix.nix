{ pkgs, ... }:

let
  # Realtek ALC887-VD on this ASUS B350 board powers up with the rear green jack (line-out)
  # muted and "Auto-Mute Mode" enabled, which mutes outputs based on front-panel jack
  # detection. Worse, the codec resets these controls back to those muted defaults on *every*
  # re-initialisation — S3 resume, and (every 10s of silence) runtime power-down to D3 — while
  # PipeWire only manages Master/PCM and never touches Front, so audio dies mid-session.
  #
  # The runtime-power-down case is handled separately by disabling snd_hda_intel power_save
  # below (so the codec stays in D0 during normal use); this script re-applies sane defaults at
  # login and on resume, for the boot and S3 cases that power_save can't cover.
  #
  # The numeric ALSA card index is assigned by probe order and is NOT stable across reboots
  # (USB/PCI enumeration varies), so resolve it from the stable Realtek codec rather than
  # hard-coding it — otherwise the fix silently targets the wrong card (e.g. NVIDIA HDMI).
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
  # See fixRealtekAudio above. Keep the HD-audio codec powered (D0) instead of dropping to D3
  # after ~10s of silence: every D3->D0 cycle re-inits the codec and re-mutes Front, which is
  # the main cause of audio dying part-way through a session. Costs a little idle power.
  boot.extraModprobeConfig = ''
    options snd_hda_intel power_save=0
  '';

  # See fixRealtekAudio above. At login this runs after WirePlumber, with a delay, because
  # WirePlumber asynchronously reconfigures the ALSA controls after its unit is considered
  # started — without the delay our values get clobbered.
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

  # The codec resets the same controls on resume from sleep, so re-apply them. A unit that is
  # WantedBy a sleep target and ordered After it is started when the machine wakes; the short
  # delay lets the codec finish re-initialising before we write the controls.
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
