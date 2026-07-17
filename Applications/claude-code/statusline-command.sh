#!/usr/bin/env bash
# Claude Code status line script
# Displays: dir | git branch | model | context usage | token counts

input=$(cat)

# --- Extract fields ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
remaining_pct=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
total_input=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_output=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')
ctx_size=$(echo "$input" | jq -r '.context_window.context_window_size // empty')

# Current input tokens in context (from last API call)
cur_input=$(echo "$input" | jq -r '.context_window.current_usage.input_tokens // empty')

# --- Directory: shorten home to ~ ---
home_dir="$HOME"
short_cwd="${cwd/#$home_dir/\~}"

# --- Git branch (skip optional locks to avoid conflicts) ---
git_branch=""
if [ -n "$cwd" ] && [ -d "$cwd/.git" ] || git -C "$cwd" --no-optional-locks rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null \
    || git -C "$cwd" --no-optional-locks rev-parse --short HEAD 2>/dev/null)
fi

# --- Context bar and urgency color ---
# Colors: Catppuccin Mocha (truecolor), matching the palette used by the
# user's Starship prompt ($XDG_CONFIG_HOME/starship/starship.toml)
RED='\033[38;2;243;139;168m'      # red
YELLOW='\033[38;2;249;226;175m'   # yellow
GREEN='\033[38;2;166;227;161m'    # green
CYAN='\033[38;2;116;199;236m'     # sapphire (model)
BLUE='\033[38;2;137;180;250m'     # blue (directory, matches starship [directory] style)
MAUVE='\033[38;2;203;166;247m'    # mauve (git branch, matches starship [git_branch] style)
OVERLAY='\033[38;2;108;112;134m'  # overlay0 (dim bar track / separators)
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

context_part=""
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  remaining_int=$(printf '%.0f' "$remaining_pct")

  # Pick color based on how full the context is
  if [ "$used_int" -ge 85 ]; then
    ctx_color="$RED"
    urgency=" (!)"
  elif [ "$used_int" -ge 60 ]; then
    ctx_color="$YELLOW"
    urgency=""
  else
    ctx_color="$GREEN"
    urgency=""
  fi

  # Build a small 10-block progress bar (filled in the urgency color,
  # empty segment dimmed) instead of plain #/- characters
  bar_filled=$(( used_int / 10 ))
  bar_empty=$(( 10 - bar_filled ))
  bar_fill=""
  bar_track=""
  for i in $(seq 1 $bar_filled); do bar_fill="${bar_fill}█"; done
  for i in $(seq 1 $bar_empty);  do bar_track="${bar_track}░"; done
  bar=$(printf "${ctx_color}%s${OVERLAY}%s${RESET}" "$bar_fill" "$bar_track")

  context_part=$(printf "${ctx_color}ctx: %d%%${RESET} ${bar}${ctx_color}%s${RESET}" "$used_int" "$urgency")
fi

# --- Token summary ---
token_part=""
if [ -n "$cur_input" ] && [ -n "$ctx_size" ]; then
  # Show current context tokens vs window size (most useful at a glance)
  cur_k=$(echo "$cur_input $ctx_size" | awk '{printf "%dk/%dk", $1/1000, $2/1000}')
  token_part=$(printf "${DIM}tokens: %s${RESET}" "$cur_k")
elif [ -n "$total_input" ]; then
  tot_k=$(printf '%.0fk' "$(echo "$total_input" | awk '{printf "%.1f", $1/1000}')")
  token_part=$(printf "${DIM}total in: %s${RESET}" "$tot_k")
fi

# --- Model ---
model_part=""
if [ -n "$model" ]; then
  model_part=$(printf "${CYAN}%s${RESET}" "$model")
fi

# --- Directory ---
dir_part=$(printf "${BOLD}${BLUE}%s${RESET}" "$short_cwd")

# --- Git branch ---
branch_part=""
if [ -n "$git_branch" ]; then
  branch_part=$(printf " ${DIM}(${RESET}${BOLD}${MAUVE}%s${RESET}${DIM})${RESET}" "$git_branch")
fi

# --- Assemble the line ---
parts=()
parts+=("$dir_part$branch_part")
[ -n "$model_part" ]   && parts+=("$model_part")
[ -n "$context_part" ] && parts+=("$context_part")
[ -n "$token_part" ]   && parts+=("$token_part")

sep=$(printf " ${DIM}|${RESET} ")

# Join parts with separator
line=""
for part in "${parts[@]}"; do
  if [ -z "$line" ]; then
    line="$part"
  else
    line="$line$sep$part"
  fi
done

printf "%b\n" "$line"
