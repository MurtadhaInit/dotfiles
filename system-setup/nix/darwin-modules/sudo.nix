# Authenticate `sudo` with Touch ID instead of typing the password.
{ ... }:

{
  security.pam.services.sudo_local = {
    touchIdAuth = true;

    # pam_reattach re-attaches sudo to the user's GUI bootstrap session. Without it the
    # Touch ID prompt never appears from inside tmux.
    # It has to load before pam_tid; nix-darwin already orders it that way.
    reattach = true;
  };
}
