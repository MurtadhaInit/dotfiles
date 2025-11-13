# priority: 7

def setup_python [] {
  use ../utils/utils.nu [ensure_homebrew_package]
  print "🔄 Setting up Python..."

  ensure_homebrew_package "uv"

  print "🔄 Installing global Python packages (tools) with uv..."
  # NOTE: The --with-executables-from flag will install those packages as
  # dependencies (if they're not already so) AND include their executables
  uv tool install sqlfluff
  uv tool install ruff
  uv tool install ansible --with-executables-from ansible-core,ansible-lint

  uv tool upgrade --all
}

setup_python