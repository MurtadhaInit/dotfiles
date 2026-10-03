#!/usr/bin/env bash
# Claude Code status line script
# Displays: dir | git branch | model (effort) | context usage | rate limits

input=$(cat)

# --- Extract fields ---
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
model=$(echo "$input" | jq -r '.model.display_name // ""')
effort=$(echo "$input" | jq -r '.effort.level // empty')
used_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
# Subscription-only, and absent until the session's first API response
five_h_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_h_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
week_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

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
PINK='\033[38;2;245;194;231m'     # pink (rate limits)
OVERLAY='\033[38;2;108;112;134m'  # overlay0 (dim bar track / separators)
BOLD='\033[1m'
DIM='\033[2m'
RESET='\033[0m'

# $2 is the color for the calm state, below the warning thresholds
urgency_color() {
  if [ "$1" -ge 85 ]; then printf '%s' "$RED"
  elif [ "$1" -ge 60 ]; then printf '%s' "$YELLOW"
  else printf '%s' "$2"
  fi
}

context_part=""
if [ -n "$used_pct" ]; then
  used_int=$(printf '%.0f' "$used_pct")
  ctx_color=$(urgency_color "$used_int" "$GREEN")
  urgency=""
  [ "$used_int" -ge 85 ] && urgency=" (!)"

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

# --- Rate limits ---
# Rendered as e.g. "5h 67% ↻ 1h40m · 7d 12%"
limit_window() {
  local pct color
  pct=$(printf '%.0f' "$2")
  color=$(urgency_color "$pct" "$PINK")
  printf "${color}%s ${BOLD}%d%%${RESET}" "$1" "$pct"
}

limits_part=""
if [ -n "$five_h_pct" ]; then
  limits_part=$(limit_window 5h "$five_h_pct")
  if [ -n "$five_h_reset" ]; then
    mins=$(( (five_h_reset - $(date +%s)) / 60 ))
    if [ "$mins" -ge 60 ]; then
      limits_part+=$(printf " ${DIM}↻ %dh%02dm${RESET}" $(( mins / 60 )) $(( mins % 60 )))
    elif [ "$mins" -gt 0 ]; then
      limits_part+=$(printf " ${DIM}↻ %dm${RESET}" "$mins")
    fi
  fi
fi
if [ -n "$week_pct" ]; then
  limits_part+="${limits_part:+ ${OVERLAY}·${RESET} }$(limit_window 7d "$week_pct")"
fi

# --- Model ---
model_part=""
if [ -n "$model" ]; then
  model_part=$(printf "${CYAN}%s${RESET}" "$model")
  # effort is absent for models that don't support the effort parameter
  [ -n "$effort" ] && model_part+=$(printf " ${DIM}(%s)${RESET}" "$effort")
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
[ -n "$limits_part" ]  && parts+=("$limits_part")

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
