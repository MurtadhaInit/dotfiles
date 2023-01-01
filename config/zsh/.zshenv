# ===== Necessary functions =====
# Check for the existence of the passed-in command but discard the outcome through redirection whether successful or erroneous because our scripts will use the exit code.
function exists() {
  # 'command -v' is similar to 'which'
  command -v $1 >/dev/null 2>&1
  # This is equivalent to:
  # command -v $1 1>/dev/null 2>/dev/null
}
