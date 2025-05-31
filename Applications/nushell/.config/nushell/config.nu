# Nushell Config File
#
# version = "0.104.0"

$env.config = {
    show_banner: false
    edit_mode: vi # or emacs
    history: {
        file_format: "sqlite" # or "plaintext"
        max_size: 100_000 # session has to be reloaded for this to take effect
        isolation: false # false allows the history to be shared across all sessions
    }
    rm: {
        always_trash: true # always act as if -t was given. Override with -p
    }
    cursor_shape: {
        # block, underscore, line, blink_block, blink_underscore, blink_line, inherit (from the terminal)
        emacs: blink_line
        vi_insert: blink_line
        vi_normal: blink_underscore
    }
    completions: {
        case_sensitive: false
        quick: true # auto-select the completion when only one remains
        partial: true
        use_ls_colors: true
        # algorithm: "prefix" # prefix, substring or fuzzy
        # sort: "smart" # "smart" (algorithm-dependent) or "alphabetical"
        external: {
            enable: true # false prevents nushell from looking into $env.PATH to find more external commands suggestions
            max_results: 100 # lower values can improve completion performance at the cost of omitting some suggestions
            # completer: null # check 'carapace_completer' above as an example
        }
    }
    use_kitty_protocol: true # a keyboard enhancement protocol supported by the Kitty Terminal
    shell_integration: {
        osc2: true # abbreviates the path if in the home_dir, sets the tab/window title, and shows the running command in the tab/window title
        osc7: true # communicate the path to the terminal
        osc8: true # shows clickable links in ls output if the terminal supports it
        osc9_9: true # from ConEmu and is starting to get wider support. It's similar to osc7 in that it communicates the path to the terminal
        osc133: true # several escapes by Final Term relating to command, output, and prompt start and end positions and exit codes
        osc633: true # an extension to OSC 133 for Visual Studio Code
        reset_application_mode: true # to keep cursor key modes in sync between the local terminal and a remote SSH host
    }
    bracketed_paste: true # paste multiple lines at once without immediate execution
    use_ansi_coloring: "auto"
    error_style: "fancy" # "plain" (for screen reader-friendly error messages)
    display_errors: {
        exit_code: false # true displays an error if an external command returns an non-zero exit code
        termination_signal: true # print an error for child process termination by all other signals
    }
    footer_mode: "auto" # or always, never, number_of_rows. When to display table footers
    table: {
        mode: default # "default", "basic", "compact", "compact_double", "heavy", "light", "none", "reinforced", "rounded", "thin", "with_love", "psql", "markdown", "dots", "restructured", "ascii_rounded", or "basic_compact" 
        index_mode: always # show index column
        header_on_separator: false # false shows header text on separator/border line
    }
    filesize: {
        unit: "metric"
        show_unit: true
        precision: 1
    }
    highlight_resolved_externals: true # true enables highlighting of external commands in the repl resolved by `which`
}

$env.PROMPT_INDICATOR = "" # Emacs mode
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""

# Transient prompt
$env.TRANSIENT_PROMPT_COMMAND = ""

# Colour theme
source "themes/catppuccin_mocha.nu"

# Atuin command history
mkdir ($nu.data-dir | path join "vendor/autoload")
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

# Starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")