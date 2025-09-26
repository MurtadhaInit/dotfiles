{ config, pkgs, ... }:

{
  imports = [
    # home-manager modules
    ../../modules/user/ssh.nix
    ../../modules/user/packages.nix
    ../../modules/user/librewolf.nix
    ../../modules/user/qbittorrent.nix
    ../../modules/user/nushell.nix
    ../../modules/user/ghostty.nix
    ../../modules/user/agenix-fonts.nix
    ../../modules/user/bun.nix
    ../../modules/user/bat.nix
    ../../modules/user/brave.nix
    ../../modules/user/bottom.nix
    ../../modules/user/eza.nix
    ../../modules/user/git-delta.nix
    ../../modules/user/lazygit.nix
    ../../modules/user/vscode.nix
    ../../modules/user/jetbrains.nix
    ../../modules/user/starship.nix
  ];

  # information about the user and their home path that's going ot be managed
  home.username = "murtadha";
  home.homeDirectory = "/home/murtadha";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.05"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/murtadha/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # programs.nushell = {
  #   enable = true;
  #   configFile.source = ~/.dotfiles/Applications/nushell/.config/nushell/config.nu;
  # };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
