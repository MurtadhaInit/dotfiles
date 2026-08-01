# priority: 0

# Install/sync VS Code extensions from a tracked, version-controlled list.
#
# The list has one `publisher.name` id per line (blank lines and lines
# starting with `#` are ignored).
#
# Default: install every id in the list that isn't already installed.
#   --cleanup  also uninstall any installed extension NOT in the list
#   --dump     overwrite the list with the currently-installed extensions, then exit
#              (use this to snapshot state after adding/removing extensions in the UI)
export def main [
  --cleanup # uninstall extensions that are not present in the list
  --dump # snapshot currently-installed extensions back into the list then exit
  list_file?: string # the extension list (defaults to Applications/vscode/extensions.list)
] {
  use ../utils/utils.nu command_exists
  let list_file = ($list_file | default $"($nu.home-dir)/.dotfiles/Applications/vscode/extensions.list")
  print "🔄 Syncing VS Code extensions..."

  if not (command_exists "code") {
    print "⚠️ 'code' CLI not found on PATH"
    return
  }

  let installed = (^code --list-extensions | lines | where { |it| ($it | str trim | is-not-empty) })

  if $dump {
    $installed | sort | to text | save --force $list_file
    print $"✅ Wrote ($installed | length) extensions to ($list_file)"
    return
  }

  if not ($list_file | path exists) {
    print $"⚠️ ($list_file) not found; nothing to install"
    return
  }

  let desired = (
    open -r $list_file
    | lines
    | each { |it| $it | str trim }
    | where { |it| ($it | is-not-empty) and not ($it | str starts-with "#") }
  )

  # compare case-insensitively; extension ids are not case-sensitive
  let installed_lower = ($installed | each { |it| $it | str lowercase })
  for ext in $desired {
    if (($ext | str lowercase) in $installed_lower) {
      print $"✅ ($ext) already installed"
    } else {
      print $"🔄 Installing ($ext)..."
      ^code --install-extension $ext --force
    }
  }

  if $cleanup {
    let desired_lower = ($desired | each { |it| $it | str lowercase })
    for ext in $installed {
      if not (($ext | str lowercase) in $desired_lower) {
        print $"🗑️ Removing ($ext)..."
        ^code --uninstall-extension $ext
      }
    }
  }

  print "✅ VS Code extensions in sync"
}
