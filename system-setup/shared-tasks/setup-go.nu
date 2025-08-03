# priority: 4

def setup_go [] {
  use ../utils/utils.nu [command_exists ensure_homebrew_package]
  print "🔄 Setting up Go..."

  if not (command_exists "gobrew") {
    with-env { GOBREW_ROOT: $"($nu.home-path)/.local/share/gobrew" } {
      curl -sLk https://git.io/gobrew | sh
      print "✅ Successfully installed gobrew"
      ^$"($env.GOBREW_ROOT)/.gobrew/bin/gobrew" use latest
      print "✅ Installed the latest version of Go"
    }
  } else {
    print "✅ gobrew is already installedp"

    gobrew self-update
    gobrew use latest
  }

  print "🔄 Installing global Go packages (tools)..."
  go install github.com/air-verse/air@latest
  go install github.com/pressly/goose/v3/cmd/goose@latest
  go install github.com/sqlc-dev/sqlc/cmd/sqlc@latest
  ensure_homebrew_package golangci-lint
}

setup_go