# priority: 13

# TODO: we need to link Nushell config files to ~/.config/nushell as well because
# it will complain later (e.g. when running scripts) when it noticed XDG_CONFIG_HOME
# is set, but not files exist at ~/.config/nushell (since they are in Application Support...)

def setup_nushell [] {
  print "🔄 Setting up Nushell..."

  # This is essentially the vendor autoload directory: https://www.nushell.sh/book/configuration.html#startup-variables
  # A vendor autoload dir is $nu.data-dir/vendor/autoload and that path is added as the last path in nu.vendor-autoload-dirs
  let tools_dir = if $nu.os-info.name == "macos" {
    # Because on macOS, the $nu.data-dir is set to the default config dir
    ([$env.HOME, "Library", "Application Support", "nushell", "vendor", "autoload"] | path join)
  } else if ($env.XDG_DATA_HOME | is-not-empty) {
    # If XDG_DATA_HOME is set, $nu.data-dir will be set to that/nushell
    ([$env.XDG_DATA_HOME, "nushell", "vendor", "autoload"] | path join)
  } else {
    print "⚠️ Couldn't determine the path to unpack shell tools' setup scripts to"
    exit 1
  }
  mkdir $tools_dir

  # Carapace command completion
  ^carapace _carapace nushell | save -f ($tools_dir | path join "carapace.nu")
  # Atuin command history
  ^atuin init nu | save -f ($tools_dir | path join "atuin.nu")
  # Starship prompt
  ^starship init nu | save -f ($tools_dir | path join "starship.nu")
  # Zoxide
  ^zoxide init nushell | save -f ($tools_dir | path join "zoxide.nu")

  print "✅ Successfully added/updated CLI tools' setup scripts for Nushell"
}

setup_nushell