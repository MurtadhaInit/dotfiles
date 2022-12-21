# make a directory and then cd into it
# TODO: load it lazily? autoload -Uz mkcd
function mkcd() {
  mkdir -p "$@" && cd "$_";
}
