export const order = 6

def setup_node [] {
  use ../utils/utils.nu [ensure_homebrew_package, command_exists]
  print "Setting up fnm for Node version management..."

  with-env {FNM_DIR: $"($nu.home-path)/.local/share/fnm"} {
    ensure_homebrew_package "fnm"
    if not (which node | get path.0 | str contains "fnm_multishells") {
      print "Installing the latest and the latest LTS versions of Node and npm with fnm..."
      fnm install --latest
      fnm install --lts
    } else {
      print "Node is already installed through fnm ✅"
    }
  }
  
  if not (command_exists pnpm) {
    corepack enable pnpm
    print "Enabled pnpm ✅"
  } else {
    print "pnpm is already present ✅"
  }

  # Install npm global packages: required dependencies for "import cost" vscode extension
  # npm install --global esbuild prettier

  ensure_homebrew_package "oven-sh/bun/bun"
  print "Installing global JS packages (tools) with Bun..."
  bun install --global @openai/codex @anthropic-ai/claude-code
}

setup_node