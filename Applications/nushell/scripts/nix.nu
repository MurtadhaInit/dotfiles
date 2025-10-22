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

if ($nu.os-info.name == "macos") and ("/nix/var/nix/profiles/default/bin" | path exists) {
  load-env (open /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | capture-foreign-env err> /dev/null)
}

# Raw output, for testing
# open /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh | capture-foreign-env err> /dev/null