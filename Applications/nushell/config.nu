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
    keybindings: [
        {
            name: delete_one_word_backward
            modifier: alt
            keycode: backspace
            mode: [emacs vi_insert]
            event: {edit: backspaceword}
        },
        {
            name: move_to_start_of_line
            modifier: None
            keycode: Char__
            mode: "vi_Normal"
            event: {edit: MoveToLineStart}
        },
        # {
        #     name: complete_one_hint_word
        #     modifier: None
        #     keycode: Char_e
        #     mode: "vi_Normal"
        #     event: {
        #         until: [
        #             { send: HistoryHintWordComplete }
        #             { edit: MoveWordRightEnd select: true } # problem
        #         ]
        #     }
        # }
        # select all line with shift + v
        # g + _ to move to the last non-blank character of the line
    ]
}

$env.PROMPT_INDICATOR = "" # Emacs mode
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.TRANSIENT_PROMPT_COMMAND = "\n" # Transient prompt
# Colour theme
source "themes/catppuccin_mocha.nu"

# Linux setup. In macOS these variables are set earlier by a service (.plist file)
if $nu.os-info.name == "macos" {
    load-env {
        # TODO: use the $nu var to get the home directory
        XDG_CONFIG_HOME: /Users/murtadha/.config
        XDG_CACHE_HOME: /Users/murtadha/.cache
        XDG_DATA_HOME: /Users/murtadha/.local/share
        XDG_STATE_HOME: /Users/murtadha/.local/state
        XDG_RUNTIME_DIR: /Users/murtadha/.local/run
        XDG_BIN_HOME: /Users/murtadha/.local/bin
    }
} else {
    load-env {
        XDG_CONFIG_HOME: /home/murtadha/.config
        XDG_CACHE_HOME: /home/murtadha/.cache
        XDG_DATA_HOME: /home/murtadha/.local/share
        XDG_STATE_HOME: /home/murtadha/.local/state
        # TODO: this should be /run/user/$UID
        # XDG_RUNTIME_DIR: /home/murtadha/.local/run
        XDG_BIN_HOME: /home/murtadha/.local/bin
    }
}

# All Homebrew shell setup is derived from: brew shellenv --help
const brew_prefix = (if $nu.os-info.name == 'macos' {'/opt/homebrew'} else {'/home/linuxbrew/.linuxbrew'})

# === Environment Variables ===
load-env {
    # Homebrew setup as per `brew shellenv`
    HOMEBREW_PREFIX: $brew_prefix,
    HOMEBREW_CELLAR: $"($brew_prefix)/Cellar",
    HOMEBREW_REPOSITORY: (if $nu.os-info.name == 'macos' {$brew_prefix} else {$"($brew_prefix)/Homebrew"}),
    INFOPATH: $"($brew_prefix)/share/info:($env.INFOPATH? | default '')",

    VISUAL: "zed --wait",
    EDITOR: "nvim",

    HOMEBREW_NO_ANALYTICS: "1", # Disable Homebrew Google analytics.
    HOMEBREW_CASK_OPTS: "--no-quarantine", # Disable Apple "trusted app" post-installation dialogues
    STARSHIP_CONFIG: $"($env.XDG_CONFIG_HOME)/starship/starship.toml", # Starship prompt config file
    EZA_CONFIG_DIR: $"($env.XDG_CONFIG_HOME)/eza", # eza config directory

    # By default, this is ~/.aws/config and by default it doesn't contain credentials
    # Credentials is typically in a separate file in ~/.aws/credentials
    # Credentials and config have been combined into a single config file here to be used.
    AWS_CONFIG_FILE: $"($nu.home-dir)/.ssh/keys/aws-config-credentials",
    # Location of the credentials file is also changed even though it's not used nor existent
    AWS_SHARED_CREDENTIALS_FILE: $"($nu.home-dir)/.ssh/keys/aws-credentials",

    # "NULLCMD": "bat" # Default to bat instead of cat

    FNM_DIR: $"($env.XDG_DATA_HOME)/fnm", # fnm root directory
    GOBREW_ROOT: $"($env.XDG_DATA_HOME)/gobrew", # gobrew root directory
    GOPATH: $"($env.XDG_DATA_HOME)/gobrew/.gobrew/current/go", # needed for global Go tools `go install ...`
    ANSIBLE_HOME: $"($env.XDG_DATA_HOME)/ansible"
    JUPYTER_CONFIG_DIR: $"($env.XDG_CONFIG_HOME)/jupyter", # Jupyter config directory
    LESSHISTFILE: $"($env.XDG_CACHE_HOME)/less/history" # less history directory
}

# Homebrew setup as per `brew shellenv`
if not ($env.MANPATH? | is-empty) {
    $env.MANPATH = $":($env.MANPATH | str trim --left --char ':')"
}

# === $PATH ===
$env.PATH = [
    $"($env.XDG_BIN_HOME)" # Python binaries installed with `uv tool install` (among others)
    $"($env.XDG_CACHE_HOME)/.bun/bin" # binaries of JS tools installed globally with `bun i -g`
    $"($env.GOBREW_ROOT)/.gobrew/bin" # gobrew binary
    $"($env.GOBREW_ROOT)/.gobrew/current/bin" # active version of Go set by gobrew
    $"($nu.home-dir)/Library/Application Support/JetBrains/Toolbox/scripts"

    # Homebrew setup as per `brew shellenv`
    $"($brew_prefix)/bin"
    $"($brew_prefix)/sbin"
    ...$env.PATH
] | uniq # remove duplicates

# === Aliases ===
alias tree = tree -aC
alias lzg = lazygit
alias lzd = lazydocker
alias man = batman
alias tf = terraform
alias k = kubectl
# To open nvim with the separate nvim-vscode config to update/debug nvim as used inside VSCode
def nvim-vscode [...args] {
    with-env { NVIM_APPNAME: "nvim-vscode" } { nvim ...$args }
}
# Update the Brewfile after adding a package
alias bbd = brew bundle dump --force --describe --file=~/.dotfiles/Homebrew/Brewfile
alias outdated = do { brew update | complete | ignore; brew outdated }
alias dot = ~/.dotfiles/system-setup/setup.nu
alias nls = do {|...rest|
    ls -al ...($rest | default -e ["."])
    | sort-by modified
    | reverse
    | sort-by type
    | select name size modified mode user group
}
alias eza = eza --long --all --header --group --group-directories-first --color-scale=all --color-scale-mode=gradient --hyperlink --sort=modified --reverse --git --icons=auto --time-style="+%d %b %y %l:%M%P"
alias ls = eza
alias macopen = ^open
# Ask LLMs quick questions in the terminal
def ? [
    --pager (-p) # Use a pager for scrolling through long output
    ...args
] {
    if ($args | is-empty) {
        print "Usage: ? <your question here>"
        return
    }
    if (which opencode | is-empty) {
        print "⚠️ Opencode is not installed"
        return
    }
    # TODO: add an option to use research mode in Claude

    # Use glow for pretty markdown rendering
    if (which glow | is-not-empty) {
        if $pager {
            ^opencode run --agent ask ...$args | glow --width 0 --pager
        } else {
            ^opencode run --agent ask ...$args | glow --width 0 -
        }
    } else {
        print "⚠️ Glow is not installed"
        ^opencode run --agent ask ...$args
    }
}

# === Tools ===
# Carapace command completions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
$env.CARAPACE_MATCH = "1"   # to do case insensitive match

# Direnv
$env.config.hooks.env_change.PWD = (
    $env.config.hooks.env_change.PWD? | append {||
        if (which direnv | is-empty) {
            return
        }
        direnv export json | from json | default {} | load-env
        $env.PATH = $env.PATH | split row (char env_sep)
    }
)

# FNM
if not (which fnm | is-empty) {
    ^fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join (if $nu.os-info.name == 'windows' {''} else {'bin'}))

    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version' 'package.json'] | any {|el| $el | path exists}}
            # NOTE: consider adding: --version-file-strategy recursive
            code: {|| ^fnm use --install-if-missing}
        }
    )
}

# fzf theme (Catppuccin mocha)
$env.FZF_DEFAULT_OPTS = "
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4"

# Nix
source "scripts/nix.nu"
