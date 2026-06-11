{ pkgs, ... }:

{
  # mise downloads prebuilt, dynamically-linked runtimes/CLIs (node, bun, the
  # standalone python, the AWS CLI, npm tools like claude-code, Go tools via aqua,
  # ...). They expect an FHS loader (/lib64/ld-linux-x86-64.so.2) and shared libs
  # under /usr/lib — neither exists on NixOS, so they fail to exec with "No such
  # file or directory". nix-ld installs a shim loader + sets NIX_LD so they run.
  #
  # IMPORTANT: this only takes effect together with `all_compile = false` in mise's
  # config.toml. On NixOS mise auto-enables all_compile (it assumes precompiled
  # binaries can't run), which would make it ignore nix-ld and build from source
  # instead — and we deliberately don't ship a source toolchain. Binary-only tools
  # (bun, aws, ...) can't be source-built anyway, so nix-ld is required regardless.
  programs.nix-ld = {
    enable = true;
    # nix-ld already ships a base set (zlib, stdenv.cc.cc → libstdc++/libgcc_s,
    # openssl, curl, systemd → libudev, util-linux → libuuid, xz, ...) and MERGES
    # it with this list. We list ONLY the extras the base lacks, aimed at
    # mise's precompiled python (ctypes/cffi, sqlite3) and node (Intl) tools.
    libraries = with pkgs; [
      libffi # python ctypes / cffi-based wheels (ansible deps, etc.)
      sqlite # python's sqlite3 module
      expat # python (pyexpat)
      ncurses
      readline
      icu # node's Intl
      libxslt
    ];
  };
}
