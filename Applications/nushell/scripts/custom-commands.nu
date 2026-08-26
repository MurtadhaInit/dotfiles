# Ask LLMs quick questions in the terminal
def ? [
    --pager (-p) # Use a pager for scrolling through long output
    ...args
] {
    if ($args | is-empty) {
        print "Usage: ? <your question here>"
        return
    }
    let query = ($args | str join " ")
    # if (which opencode | is-empty) {
    if (which claude | is-empty) {
        # print "⚠️ OpenCode is not installed"
        print "⚠️ Claude Code is not installed"
        return
    }

    # Use glow for pretty markdown rendering
    if (which glow | is-not-empty) {
        if $pager {
            # ^opencode run --agent ask ...$args | glow --width 0 --pager
            ^claude -p $query | glow --width 0 --pager
        } else {
            # ^opencode run --agent ask ...$args | glow --width 0 -
            ^claude -p $query | glow --width 0 -
        }
    } else {
        print "⚠️ Glow is not installed"
        # ^opencode run --agent ask ...$args
        ^claude -p $query
    }
}

# Show outdated packages
def outdated [] {
    print $"(ansi cyan_bold)=== Mise ===(ansi reset)"
    mise outdated

    print $"\n(ansi yellow_bold)=== Homebrew ===(ansi reset)"
    brew update | complete | ignore
    let brew_output = (brew outdated)
    if ($brew_output | is-empty) {
        print "Nothing to update"
    } else {
        print $brew_output
    }
}