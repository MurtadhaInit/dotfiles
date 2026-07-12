# priority: 13

def setup_nushell [] {
  print "🔄 Setting up Nushell..."

  # On macOS, $nu.data-dir depends on launch context: a freshly launched nu (e.g. a new
  # terminal tab) resolves it to ~/Library/Application Support/nushell because the XDG_*
  # vars are only exported later by config.nu, while a nu started from an already-configured
  # environment (tmux, scripts) resolves it to ~/.local/share/nushell (by reading $XDG_DATA_HOME).
  # Symlink the former's vendor dir to the latter so both contexts read and write the same scripts.
  if $nu.os-info.name == "macos" {
    let xdg_vendor = ($nu.home-dir | path join ".local" "share" "nushell" "vendor")
    let as_vendor = ($nu.home-dir | path join "Library" "Application Support" "nushell" "vendor")
    mkdir ($xdg_vendor | path join "autoload")
    if ($as_vendor | path type) == "dir" { rm -r $as_vendor }
    if ($as_vendor | path type) != "symlink" { ^ln -s $xdg_vendor $as_vendor }
  }

  # This is essentially the user's vendor autoload directory: https://www.nushell.sh/book/configuration.html#startup-variables
  # It's $nu.data-dir/vendor/autoload and that path is added as the last entry in nu.vendor-autoload-dirs (highest priority).
  # Every script placed in there is automatically loaded on interactive (REPL) shell startups, e.g. new tabs,
  # but not in -c or script runs. They load after config.nu (which is why mise's stale PATH snapshot below
  # would clobber the PATH config.nu just built).
  let tools_dir = ($nu.data-dir | path join "vendor" "autoload")
  mkdir $tools_dir

  # Carapace command completion
  ^carapace _carapace nushell | save -f ($tools_dir | path join "carapace.nu")
  # Atuin command history
  ^atuin init nu | save -f ($tools_dir | path join "atuin.nu")
  # Starship prompt
  ^starship init nu | save -f ($tools_dir | path join "starship.nu")
  # Zoxide
  ^zoxide init nushell | save -f ($tools_dir | path join "zoxide.nu")
  # Mise-en-place
  # NOTE: the generated activation script snapshots the current $PATH which becomes stale when config.nu changes.
  # Stripping the PATH line lets mise's hook-env dynamically build PATH on the first prompt instead.
  ^mise activate nu | lines | where { $in !~ '^set,PATH,' } | str join "\n" | save -f ($tools_dir | path join "mise.nu")

  print "✅ Successfully added/updated CLI tools' setup scripts for Nushell"
}

setup_nushell