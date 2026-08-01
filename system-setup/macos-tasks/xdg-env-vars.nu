# priority: 10

# Set the XDG_* environment variables early on so that Nushell can correctly pick up
# the config location in ~/.config/nushell
# Note: the bin and runtime directories are not included in my original ZSH config.
# And the runtime dir was pointing to "/run/user/$UID" (it was commented out).
export def main [] {
  let file = "./files/murtadha.xdg.vars.plist"
  print "Setting up XDG_* environment variables..."

  cp --verbose --update $file $"($nu.home-dir)/Library/LaunchAgents/"

  let file_name = $file | path basename
  let service_name = $file | path parse | get stem
  let is_loaded = launchctl list | lines | any { |line| $line =~ $service_name }
  if not $is_loaded {
    print $"Loading service: ($service_name)..."
    launchctl load $"($nu.home-dir)/Library/LaunchAgents/($file_name)"
  } else {
    print $"Service ($service_name) is already loaded ✅"
  }
}
