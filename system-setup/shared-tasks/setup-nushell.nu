# priority: 13

def setup_nushell [] {
  print "🔄 Setting up Nushell..."

  let tools_dir = ($nu.data-dir | path join "vendor/autoload")
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