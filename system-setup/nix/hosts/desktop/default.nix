{ pkgs, ... }:

let
  # Realtek ALC887-VD on this ASUS B350 board powers up with the rear green jack (line-out)
  # muted and "Auto-Mute Mode" enabled, which mutes outputs based on front-panel jack
  # detection. The codec also resets these same controls back to those defaults when resuming
  # from S3 sleep, killing audio output. Re-apply sane defaults at login and again on resume.
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
  imports = [
    # Host-specific hardware modules
    ./hardware/hardware-configuration.nix # NOTE: copy the generated results of the hardware scan
    ./hardware/storage.nix # NOTE: edit the UUIDs of HDDs according to the new system before switching

    # System-level modules
    ../../nixos-modules/nvidia.nix
    ../../nixos-modules/fonts.nix
    ../../nixos-modules/nh.nix
    ../../nixos-modules/zsa.nix
    ../../nixos-modules/locale.nix
    ../../nixos-modules/audio.nix
    ../../nixos-modules/firewall.nix
    ../../nixos-modules/networking.nix
    ../../nixos-modules/tailscale.nix
    ../../nixos-modules/default-shell.nix
    ../../nixos-modules/nix-ld.nix
    ../../nixos-modules/helium.nix
  ];

  networking.hostName = "nixos-workstation";

  # NOTE: change the values for the encrypted SSD on a new system before switching
  boot.initrd.luks.devices."luks-437bdffa-1ff4-42cf-b1a4-0b93b7ad318d".device =
    "/dev/disk/by-uuid/437bdffa-1ff4-42cf-b1a4-0b93b7ad318d";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    murtadha = {
      isNormalUser = true;
      description = "Murtadha";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      packages = with pkgs; [
        kdePackages.kate
      ];
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin = {
    enable = true;
    user = "murtadha";
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Install Steam
  programs.steam.enable = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    wget
    git
    curl
    vim
  ];

  # TODO: System upgrades
  # system.autoUpgrade = {
  #   enable = true;
  #   allowReboot = false;
  #   flake = ~/.dotfiles/system-setup/nix/flake.nix;
  # };

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    # enableSSHSupport = true; # disabled because it conflicts with ssh.startAgent (can't both be enabled)
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

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
