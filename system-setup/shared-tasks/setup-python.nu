# priority: 7

def setup_python [] {
  use ../utils/utils.nu [ensure_homebrew_package, command_exists]
  print "🔄 Setting up Python..."

  mkdir --verbose $"($nu.home-path)/.local/share/pyenv"
  with-env { PYENV_ROOT: $"($nu.home-path)/.local/share/pyenv", PYTHON_CONFIGURE_OPTS: "--enable-optimizations --with-lto", PYTHON_CFLAGS: "-march=native -mtune=native" } {
    ensure_homebrew_package "pyenv"

    if not ((command_exists "python") and (which python | get path.0 | str contains "pyenv")) {
      print "🔄 Installing the latest version of Python 3 with pyenv..."
      pyenv install --skip-existing 3
      pyenv global 3
      print "✅ Successfully installed and set up the latest version of Python 3"
    } else {
      print "✅ Python 3 is already installed through pyenv"
    }
  }

  ensure_homebrew_package "uv"

  print "🔄 Installing global Python packages (tools) with uv..."
  uv tool install sqlfluff
  # use uv to install Ansible along with its dependencies
}

setup_python