echo 'Hello from .zshenv!'

function exists() {
  # 'command -v' is similar to 'which'
  command -v $1 >/dev/null 2>&1
  # This is equivalent to:
  # command -v $1 1>/dev/null 2>/dev/null
}
