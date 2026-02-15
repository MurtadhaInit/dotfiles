# Returns a record of changed env variables after running a non-nushell script's contents (passed via stdin), e.g. a bash script you want to "source"
# 
# Source: https://www.nushell.sh/cookbook/foreign_shell_scripts.html#capturing-the-environment-from-a-foreign-shell-script
def capture-foreign-env [
    --shell (-s): string = /bin/sh
    # The shell to run the script in
    # (has to support '-c' argument and POSIX 'env', 'echo', 'eval' commands)
    --arguments (-a): list<string> = []
    # Additional command line arguments to pass to the foreign shell
] {
    let script_contents = $in;
    let env_out = with-env { SCRIPT_TO_SOURCE: $script_contents } {
        ^$shell ...$arguments -c `
        env
        echo '<ENV_CAPTURE_EVAL_FENCE>'
        eval "$SCRIPT_TO_SOURCE"
        echo '<ENV_CAPTURE_EVAL_FENCE>'
        env -0 -u _ -u _AST_FEATURES -u SHLVL` # Filter out known changing variables
    }
    | split row '<ENV_CAPTURE_EVAL_FENCE>'
    | {
        before: ($in | first | str trim | lines)
        after: ($in | last | str trim | split row (char --integer 0))
    }

    # Unfortunate Assumption:
    # No changed env var contains newlines (not cleanly parseable)
    $env_out.after
    | where { |line| $line not-in $env_out.before } # Only get changed lines
    | parse "{key}={value}"
    | transpose --header-row --as-record
    | if $in == [] { {} } else { $in }
}

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