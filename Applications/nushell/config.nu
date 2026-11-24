# Merged into the defaults rather than replacing them
$env.config = ($env.config | merge deep --strategy append {
    show_banner: false
    edit_mode: vi
    history: {
        file_format: "sqlite"
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
    use_kitty_protocol: true # a keyboard enhancement protocol supported by the Kitty Terminal
    shell_integration: {
        osc9_9: true # like osc7, communicates the path to the terminal (from ConEmu, gaining wider support)
    }
    footer_mode: "auto" # or always, never, number_of_rows. When to display table footers
    table: {
        mode: default # "default", "basic", "compact", "compact_double", "heavy", "light", "none", "reinforced", "rounded", "thin", "with_love", "psql", "markdown", "dots", "restructured", "ascii_rounded", or "basic_compact"
    }
    highlight_resolved_externals: true # highlight external commands in the repl resolved by `which`
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
        {
            # At the end of the input, accept the next word of the history hint, otherwise a plain e motion
            name: complete_one_hint_word
            modifier: None
            keycode: Char_e
            mode: "vi_Normal"
            event: {
                until: [
                    { send: HistoryHintWordComplete }
                    { edit: MoveWordRightEnd select: false }
                ]
            }
        },
        {
            # Emulates vim's V: a plain visual selection that starts as the whole line, not a linewise mode
            name: select_line
            modifier: Shift
            keycode: Char_v
            mode: "vi_Normal"
            event: [
                { send: SwitchMode mode: vi_visual }
                { edit: SelectLine }
            ]
        }
        # g + _ to move to the last non-blank character of the line
    ]
})

$env.PROMPT_INDICATOR = "" # Emacs mode
$env.PROMPT_INDICATOR_VI_INSERT = ""
$env.PROMPT_INDICATOR_VI_NORMAL = ""
$env.TRANSIENT_PROMPT_COMMAND = "\n" # Transient prompt

source "themes/catppuccin_mocha.nu" # Colour theme
source "scripts/custom-commands.nu"
source "scripts/github-backup.nu"

# macOS system paths and manpaths — replaces path_helper which is invoked from /etc/zprofile
# patch_helper reads /etc/paths, /etc/paths.d/*, /etc/manpaths, and /etc/manpaths.d/* (man patch_helper)
let system_paths = (
    if $nu.os-info.name == "macos" {
        [/etc/paths ...(glob /etc/paths.d/*)] | each { open $in | lines | where { $in | is-not-empty } } | flatten
    } else { [] }
)
let system_manpaths = (
    if $nu.os-info.name == "macos" and ('/etc/manpaths' | path exists) {
        [/etc/manpaths ...(glob /etc/manpaths.d/*)] | each { open $in | lines | where { $in | is-not-empty } } | flatten
    } else { [] }
)

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
    STARSHIP_CONFIG: $"($env.XDG_CONFIG_HOME)/starship/starship.toml", # Starship prompt config file
    EZA_CONFIG_DIR: $"($env.XDG_CONFIG_HOME)/eza", # eza config directory
}

# herdr and tmux export their own pane shell as $SHELL (nu, /bin/sh). Restore the account's
# login shell so tools that spawn "the user's shell" (nvim, fzf) get the same one everywhere.
$env.SHELL = (
    (if $nu.os-info.name == "macos" { ^id -P } else { ^getent passwd $env.USER })
    | split row ":" | last | str trim
)

# System manpaths from /etc/manpaths and /etc/manpaths.d/*
if ($system_manpaths | is-not-empty) {
    $env.MANPATH = ($system_manpaths
        | append ($env.MANPATH? | default "" | split row (char env_sep))
        | where { $in | is-not-empty }
        | uniq
        | str join (char env_sep)
)}
# Homebrew setup as per `brew shellenv`
if not ($env.MANPATH? | is-empty) {
    $env.MANPATH = $":($env.MANPATH | str trim --left --char ':')"
}

# === $PATH ===
$env.PATH = [
    $"($env.XDG_BIN_HOME)" # `uv tool install` CLIs go there + other things like Orbstack and Docker
    $"($nu.home-dir)/Library/Application Support/JetBrains/Toolbox/scripts"

    # Homebrew setup as per `brew shellenv`
    $"($brew_prefix)/bin"
    $"($brew_prefix)/sbin"

    ...$system_paths
    ...$env.PATH
] | uniq # remove duplicates

# === Aliases ===
alias tree = tree -aC
alias lzg = lazygit
alias lzd = lazydocker
alias man = batman
alias k = kubectl
alias t = talosctl
# To open nvim with the separate nvim-vscode config to update/debug nvim as used inside VSCode
def nvim-vscode [...args] {
    with-env { NVIM_APPNAME: "nvim-vscode" } { nvim ...$args }
}
# Update the Brewfile after adding a package
alias bbd = brew bundle dump --force --describe --file=~/.dotfiles/Homebrew/Brewfile
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
alias lsc = eza --loc
alias macopen = ^open

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

# fzf theme (Catppuccin mocha)
$env.FZF_DEFAULT_OPTS = "
--color=bg+:#313244,bg:#1E1E2E,spinner:#F5E0DC,hl:#F38BA8
--color=fg:#CDD6F4,header:#F38BA8,info:#CBA6F7,pointer:#F5E0DC
--color=marker:#B4BEFE,fg+:#CDD6F4,prompt:#CBA6F7,hl+:#F38BA8
--color=selected-bg:#45475A
--color=border:#6C7086,label:#CDD6F4"

# Nix
# Determinate's installer only hooks /etc/{zshrc,bashrc,profile} and adds no /etc/paths.d entry,
# so nushell has to set up the profiles itself. Done natively rather than by sourcing
# nix-daemon.sh through capture-foreign-env: that helper can't diff multiline values, so it
# leaked its own 3KB SCRIPT_TO_SOURCE into the environment of every child process.
if ($nu.os-info.name == "macos") and ("/nix/var/nix/profiles/default/bin" | path exists) {
  let user_profile = $"($nu.home-dir)/.nix-profile"
  let default_profile = "/nix/var/nix/profiles/default"

  $env.NIX_PROFILES = $"($default_profile) ($user_profile)"
  $env.NIX_SSL_CERT_FILE = $"($default_profile)/etc/ssl/certs/ca-bundle.crt"
  $env.PATH = ($env.PATH | prepend [$"($user_profile)/bin" $"($default_profile)/bin"] | uniq)
  $env.XDG_DATA_DIRS = (
    $env.XDG_DATA_DIRS? | default "/usr/local/share:/usr/share"
    | split row (char env_sep)
    | append [$"($user_profile)/share" $"($default_profile)/share"]
    | uniq
    | str join (char env_sep)
  )

  # Stops a zsh/bash child from prepending the same entries again.
  $env.__ETC_PROFILE_NIX_SOURCED = "1"
}

# nix-darwin's system profile, holding darwin-rebuild and anything in
# environment.systemPackages. /etc/zshrc is what normally puts this on PATH, but we
# keep nix-darwin out of the system shell files (darwin-modules/shells.nix), so
# nushell adds it. The guard makes it a no-op until a generation has been activated.
if ($nu.os-info.name == "macos") and ("/run/current-system/sw/bin" | path exists) {
  $env.PATH = ($env.PATH | append "/run/current-system/sw/bin" | uniq)
}
