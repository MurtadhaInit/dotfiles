
if exists go: then
    echo "$(go version) already installed"
else
    echo "Installing gobrew (Go version manager)..."
    zsh # to source the env variable for gobrew home dirctory
    curl -sLk https://git.io/gobrew | sh
    zsh # to re-source the $path variable and make gobrew available
    gobrew version

    echo "Installing the latest version of Go using gobrew..."
    gobrew use latest

# TODO: find a better way of sourcing changes mid-script instead of calling zsh and starting a subshell