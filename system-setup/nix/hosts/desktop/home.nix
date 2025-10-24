{ config, pkgs, ... }:

{
  imports = [
    # home-manager modules
    ../../hm-modules/ssh.nix
    ../../hm-modules/packages.nix
    ../../hm-modules/librewolf.nix
    ../../hm-modules/qbittorrent.nix
    ../../hm-modules/nushell.nix
    ../../hm-modules/ghostty.nix
    ../../hm-modules/agenix-fonts.nix
    ../../hm-modules/bun.nix
    ../../hm-modules/bat.nix
    ../../hm-modules/brave.nix
    ../../hm-modules/bottom.nix
    ../../hm-modules/eza.nix
    ../../hm-modules/git-delta.nix
    ../../hm-modules/lazygit.nix
    ../../hm-modules/vscode.nix
    ../../hm-modules/jetbrains.nix
    ../../hm-modules/starship.nix
    ../../hm-modules/helix.nix
    ../../hm-modules/LSPs.nix
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
