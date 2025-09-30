{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    neovim
    zed-editor
    ghostty
    vlc
    localsend
    stow
    uv
    ruff
    sqlfluff
    atuin # also available as a flake
    zoxide
    fzf
    ripgrep
    carapace
    fd
    obsidian
    gh
    drawio
    legcord
    zotero
    tree
    lazydocker
    libreoffice-qt-fresh
    hunspell # for libreoffice (spellcheck)
    hunspellDicts.en-us # for libreoffice (spellcheck)
    hunspellDicts.en-gb-ise # for libreoffice (spellcheck)
    dig
    signal-desktop
    rustdesk-flutter
    age
    nur.repos.charmbracelet.crush
    papers # cause Okular is kinda trash
    claude-code

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];
}
