# priority: 8

def setup_node [] {
  use ../utils/utils.nu [ensure_homebrew_package, command_exists]
  print "Setting up fnm for Node version management..."

  with-env {FNM_DIR: $"($nu.home-path)/.local/share/fnm"} {
    ensure_homebrew_package "fnm"
    if (which node | is-empty) or not (which node | get path.0 | str contains "fnm_multishells") {
      print "Installing the latest and the latest LTS versions of Node and npm with fnm..."
      fnm install --latest
      fnm install --lts
    } else {
      print "Node is already installed through fnm ✅"
    }
  }
  
  if not (command_exists pnpm) {
    if (command_exists corepack) {
      ^corepack enable pnpm
      print "Enabled pnpm ✅"
    } else {
      print "Couldn't find corepack. pnpm not added ❗️"
    }
  } else {
    print "pnpm is already present ✅"
  }

  ensure_homebrew_package "oven-sh/bun/bun"
  print "Installing/updating global JS packages (tools) with Bun..."
  bun install --global @openai/codex @anthropic-ai/claude-code @google/gemini-cli
}

setup_node