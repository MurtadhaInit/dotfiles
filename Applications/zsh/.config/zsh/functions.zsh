# Make a directory and then cd into it
function mkcd() {
  mkdir -p "$@" && cd "$_";
}

# View a cheat sheet for any app or technology using cheat.sh
# NOTE: use this or tldr
function chtsht() {
  curl cheat.sh/$@
}
