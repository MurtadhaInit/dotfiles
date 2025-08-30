{ config, pkgs, ... }:

{
  imports = [
    # Host-specific hardware modules
    ./hardware/hardware-configuration.nix # the generated results of the hardware scan
    ./hardware/storage.nix

    # System-level modules
    ../../modules/system/nvidia.nix
    ../../modules/system/fonts.nix
    ../../modules/system/nh.nix
    ../../modules/system/zsa.nix
    ../../modules/system/locale.nix
    ../../modules/system/audio.nix
    ../../modules/system/firewall.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-workstation";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

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

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users = {
    murtadha = {
      isNormalUser = true;
      description = "Murtadha";
      extraGroups = [
        "networkmanager"
        "wheel"
      ];
      shell = pkgs.nushell;
      packages = with pkgs; [
        kdePackages.kate
      ];
    };
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "murtadha";

  # Install firefox.
  programs.firefox.enable = true;

  # Install Steam
  programs.steam.enable = true;

  # Enbale Nushell
  environment.shells = [
    pkgs.nushell
  ];

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
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

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
