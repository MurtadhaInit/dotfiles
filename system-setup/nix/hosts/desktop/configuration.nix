{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # Host-specific hardware modules
    ./hardware/storage.nix

    # System-level modules
    ../../system/nvidia.nix
    ../../system/fonts.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "nixos-workstation"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Asia/Amman";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ar_JO.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "ar_JO.UTF-8";
    LC_MONETARY = "ar_JO.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "ar_JO.UTF-8";
    LC_TELEPHONE = "ar_JO.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

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

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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
        neovim
        ghostty
        brave
        vlc
        localsend
        vscode
        stow
        nixfmt-rfc-style
        uv
        ruff
        sqlfluff
        starship
        atuin # also available as a flake
        bat
        bat-extras.core
        eza # also available as a flake
        zoxide
        fzf
        ripgrep
        carapace
        fd
        delta
        obsidian
        gh
        drawio
        legcord
        zotero
        qbittorrent
        tree
        zed-editor
        bottom
        lazygit
        lazydocker
        libreoffice-qt6-fresh
        hunspell # for libreoffice (spellcheck)
        hunspellDicts.en-us # for libreoffice (spellcheck)
        hunspellDicts.en-gb-ise # for libreoffice (spellcheck)
        dig
        signal-desktop
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
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    git
    curl
    vim
    librewolf
  ];

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

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

  # Start the OpenSSH private key agent when you log in (to avoid re-entering the passphrase everytime you make an SSH connection)
  programs.ssh.startAgent = true;

  # Some configurations for SSH (as in ~/.ssh/config)
  programs.ssh.extraConfig = ''
    Host github.com
      IdentityFile ~/.ssh/keys/github
  '';

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    53317 # for LocalSend
    15522 # for qBitorrent
  ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
