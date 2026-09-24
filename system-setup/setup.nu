#!/usr/bin/env nu

# Pick and run ad-hoc setup tasks (one `tasks/*.nu` file each).
#
# Tasks run with their defaults here. To pass flags, run a task directly.
# Tasks are cross-platform and handle OS differences themselves.
def main []: nothing -> nothing {
  const tasks_dir = path self tasks
  # fzf shows the task name but returns its path; Esc/no match yields nothing.
  # The picker colours are Catppuccin Mocha, and bat's preview is forced to its dark theme
  # to match (under fzf it can't detect light/dark and falls back to a non-Catppuccin default).
  let picked = try {
    (glob ($tasks_dir | path join *.nu)
    | sort
    | each {|p| $"($p)\t($p | path parse | get stem)" }
    | str join "\n"
    | ^fzf --multi --delimiter "\t" --with-nth 2 --accept-nth 1
        --bind ctrl-a:select-all
        --height "80%"
        --border bottom
        --border-label " Tab: select · C-a: all · Enter: run · Esc: cancel "
        --prompt "❯ "
        --pointer "▶"
        --marker "✓ "
        --color "label:italic:#cba6f7,marker:bold:#a6e3a1,pointer:#cba6f7,current-bg:#313244"
        --preview "bat --color=always --style=plain --theme=dark {1}"
        --preview-window "right:80%:wrap"
    | lines)
  } catch { [] }

  for task in $picked {
    print $"▶ ($task | path parse | get stem)"
    nu $task
  }
}
