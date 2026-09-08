# Desktop & Dock > Windows. Stage Manager itself stays off, which is the macOS default.
{ ... }:

{
  system.defaults.WindowManager = {
    # "Tiled windows have margins" off: tiles sit flush against each other and the
    # screen edge.
    EnableTiledWindowMargins = false;

    # "Drag windows to menu bar to fill screen" off. Edge tiling to the sides and
    # corners is untouched (EnableTilingByEdgeDrag is left at its default of on), so
    # only the top edge loses its Sequoia meaning.
    EnableTopTilingByEdgeDrag = false;
  };
}
