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

# Keybindings
$env.config.keybindings ++= [
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
    # change inside word
    # select all line with shift + v
    # g + _ to move to the last non-blank character of the line
]

# Environment Variables
load-env {
    # Homebrew setup as per `brew shellenv`
    "HOMEBREW_PREFIX": "/opt/homebrew"
    "HOMEBREW_CELLAR": "/opt/homebrew/Cellar"
    "HOMEBREW_REPOSITORY": "/opt/homebrew"
    "INFOPATH": $"/opt/homebrew/share/info:($env.INFOPATH? | default '')"

    "VISUAL": "code"
    "EDITOR": "vim"

    # TODO: it's originally without quotes
    "HOMEBREW_NO_ANALYTICS": "1" # Disable Homebrew Google analytics.
    "HOMEBREW_CASK_OPTS": "--no-quarantine" # Disable Apple "trusted app" post-installation dialogues 
    "STARSHIP_CONFIG": $"($env.XDG_CONFIG_HOME)/starship/starship.toml" # Starship prompt config file

    # By default, this is ~/.aws/config and by default it doesn't contain credentials
    # Credentials is typically in a separate file in ~/.aws/credentials
    # Credentials and config have been combined into a single config file here to be used.
    "AWS_CONFIG_FILE": $"($nu.home-path)/.ssh/keys/aws-config-credentials"
    # Location of the credentials file is also changed even though it's not used nor existent
    "AWS_SHARED_CREDENTIALS_FILE": $"($nu.home-path)/.ssh/keys/aws-credentials"

    # "NULLCMD": "bat" # Default to bat instead of cat
    # "ANDROID_HOME": $"($nu.home-path)/Library/Android/sdk" # Android SDKs location
    # "VAGRANT_HOME": $"($env.XDG_DATA_HOME)/vagrant" # Vagrant root directory
    # "DOCKER_CONFIG": $"($env.XDG_CONFIG_HOME)/docker" # Docker

    "PYENV_ROOT": $"($env.XDG_DATA_HOME)/pyenv" # pyenv root directory
    "FNM_DIR": $"($env.XDG_DATA_HOME)/fnm" # fnm root directory
    "GOBREW_ROOT": $"($env.XDG_DATA_HOME)/gobrew" # gobrew root directory
    # TODO: check if this works
    "GOROOT": $"($env.GOBREW_ROOT)/.gobrew/current/go" # Set GOROOT according to the active version of Go set by gobrew
    "JUPYTER_CONFIG_DIR": $"($env.XDG_CONFIG_HOME)/jupyter" # Jupyter config directory
    "LESSHISTFILE": $"($env.XDG_CACHE_HOME)/less/history" # less history directory
}

# Homebrew setup as per `brew shellenv`
# [ -z "${MANPATH-}" ] || export MANPATH=":${MANPATH#:}";
if not ($env.MANPATH? | is-empty) {
    $env.MANPATH = $":($env.MANPATH | str trim --left --char ':')"
}

# $PATH
$env.PATH = [
    # Homebrew setup as per `brew shellenv` 
    "/opt/homebrew/bin"
    "/opt/homebrew/sbin"
    $"($env.XDG_BIN_HOME)"
    $"($env.PYENV_ROOT)/shims"
    $"($env.XDG_CACHE_HOME)/.bun/bin" # binaries of JS tools installed globally with `bun i -g`
    # $"(brew --prefix openjdk)/bin" # Homebrew JDK
    $"($env.GOBREW_ROOT)/.gobrew/bin" # gobrew binary
    $"($env.GOBREW_ROOT)/.gobrew/current/bin" # active version of Go set by gobrew
    # $"($env.ANDROID_HOME)/emulator" # Android Development
    # $"($env.ANDROID_HOME)/platform-tools" # Android Development
    $"($nu.home-path)/Library/Application Support/JetBrains/Toolbox/scripts" # JetBrains
    ...$env.PATH
]
$env.PATH = ($env.PATH | uniq) # remove duplicates

# === Aliases ===
alias tree = tree -daC
alias lzg = lazygit
alias lzd = lazydocker
alias man = batman
# To open nvim with the separate nvim-vscode config to update/debug nvim as used inside VSCode
alias nvim-vscode = NVIM_APPNAME="nvim-vscode" nvim
# Update the Brewfile after adding a package
alias bbd = brew bundle dump --force --describe --file=~/.dotfiles/Homebrew/Brewfile
# Show outdated formulas & casks
# TODO: fix below to be nushell compliant
# alias outdated = brew update &>/dev/null && brew outdated
# dotfiles script
alias dot = ~/.dotfiles/system-setup/setup.nu
# alias grep = grep --color
# alias zj = zellij

# Carapace command completions
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,inshellisense'
mkdir ($nu.data-dir | path join "vendor/autoload")
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")
# source ($nu.data_dir | path join "vendor/autoload/carapace.nu") 

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
    fnm env --json | from json | load-env

    $env.PATH = $env.PATH | prepend ($env.FNM_MULTISHELL_PATH | path join "bin")

    $env.config.hooks.env_change.PWD = (
        $env.config.hooks.env_change.PWD? | append {
            condition: {|| ['.nvmrc' '.node-version'] | any {|el| $el | path exists}}
            code: {|| fnm use}
        }
    )
}

# Zoxide
mkdir ($nu.data-dir | path join "vendor/autoload")
zoxide init nushell | save -f ($nu.data-dir | path join "vendor/autoload/zoxide.nu")
# source ~/.zoxide.nu

# Atuin command history
mkdir ($nu.data-dir | path join "vendor/autoload")
atuin init nu | save -f ($nu.data-dir | path join "vendor/autoload/atuin.nu")

# Starship prompt
mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")

# === From vars.zsh ===

# fzf Catppuccin (Frappé) colours: https://github.com/catppuccin/fzf
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#414559,bg:#303446,spinner:#f2d5cf,hl:#e78284 \
# --color=fg:#c6d0f5,header:#e78284,info:#ca9ee6,pointer:#f2d5cf \
# --color=marker:#f2d5cf,fg+:#c6d0f5,prompt:#ca9ee6,hl+:#e78284"

# fzf Catppuccin (Mocha) colours: https://github.com/catppuccin/fzf
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
# --color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
# --color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# fzf Catppuccin (Macchiato) colours: https://github.com/catppuccin/fzf
# export FZF_DEFAULT_OPTS=" \
# --color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
# --color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
# --color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"
