#!/usr/bin/env bash

######################################
# bash-tui-primitives.sh #########
# version: 0.0.1         #####
##########################

####################
# VARIABLES #####
#############

# COLORS
TUI_CLR_DEFAULT=$'\033[0m'
TUI_CLR_RED=$'\033[0;31m'
TUI_CLR_GREEN=$'\033[0;32m'
TUI_CLR_YELLOW=$'\033[1;33m'
TUI_CLR_BLUE=$'\033[0;34m'
TUI_CLR_MAGENTA=$'\033[0;35m'
TUI_CLR_CYAN=$'\033[0;36m'
TUI_CLR_WHITE=$'\033[1;37m'

###################
# MODIFIERS ####
#############

CAP_WIDTH=80      # Will limit tui components to a certain width.
#BOX_CHAR="#"      # Default char the box is made of (default: #)
#SEP_CHAR="-"      # Default char the separator is made of (default: -)
#PROG_BAR_CHAR="#" # Default char the progress bar is made of (default: #)

###################
# FUNCTIONS ####
#############

# ==============================================================================
# print:  prints text without newline
# Usage:  tui_print "Hello World" TUI_CLR_RED
#         Second parameter is optional; defaults to TUI_CLR_DEFAULT
# ==============================================================================
tui_print() {
  local text="$1"
  local color="${2:-$TUI_CLR_DEFAULT}"

  printf "%b" "${color}${text}${TUI_CLR_DEFAULT}"
}

# ==============================================================================
# println: prints text with newline
# Usage:   tui_println "Hello World" TUI_CLR_GREEN
#          Second parameter is optional; defaults to TUI_CLR_DEFAULT
# ==============================================================================
tui_println() {
  local text="$1"
  local color="${2:-$TUI_CLR_DEFAULT}"

  printf "%b\n" "${color}${text}${TUI_CLR_DEFAULT}"
}

# ==============================================================================
# print_ok: prints text in green
# Usage:    tui_print_ok "OK"
# Source:   bash-tui-primitives by Timax
#           github.com/dancesWithMachines/bash-tui-primitives
# ==============================================================================
tui_print_ok() {
  local text="$1"
  local clr_green=$'\033[0;32m'
  local clr_default=$'\033[0m'

  printf "%b" "${clr_green}${text}${clr_default}"
}

# ==============================================================================
# print_warn: prints text in yellow
# Usage:      tui_print_warn "WARN"
# ==============================================================================
tui_print_warn() {
  local text="$1"
  local clr_yellow=$'\033[1;33m'
  local clr_default=$'\033[0m'

  printf "%b" "${clr_yellow}${text}${clr_default}"
}

# ==============================================================================
# print_err: prints text in red
# Usage:     tui_print_err "ERROR"
# ==============================================================================
tui_print_err() {
  local text="$1"
  local clr_red=$'\033[0;31m'
  local clr_default=$'\033[0m'

  printf "%b" "${clr_red}${text}${clr_default}"
}

# ==============================================================================
# println_ok: prints text in green with newline
# Usage:    tui_println_ok "OK"
# ==============================================================================
tui_println_ok() {
  local text="$1"
  local clr_green=$'\033[0;32m'
  local clr_default=$'\033[0m'

  printf "%b\n" "${clr_green}${text}${clr_default}"
}

# ==============================================================================
# println_warn: prints text in yellow with newline
# Usage:    tui_println_warn "WARN"
# ==============================================================================
tui_println_warn() {
  local text="$1"
  local clr_yellow=$'\033[1;33m'
  local clr_default=$'\033[0m'

  printf "%b\n" "${clr_yellow}${text}${clr_default}"
}

# ==============================================================================
# println_err: prints text in red with newline
# Usage:    tui_println_err "ERROR"
# ==============================================================================
tui_println_err() {
  local text="$1"
  local clr_red=$'\033[0;31m'
  local clr_default=$'\033[0m'

  printf "%b\n" "${clr_red}${text}${clr_default}"
}

# ==============================================================================
# box:    prints single-line text inside a colored box
# Usage:  tui_box "Hello World" TUI_CLR_BLUE TUI_CLR_WHITE
# ==============================================================================
tui_box() {
  local text="$1"
  local box_color="${2:-$'\033[0m'}"
  local text_color="${3:-$'\033[0m'}"
  local box_char="${BOX_CHAR:-#}"
  local clr_default=$'\033[0m'
  local term_width max_text_width display_text border

  # Determine box width
  if [[ -n "$CAP_WIDTH" && "$CAP_WIDTH" =~ ^[0-9]+$ ]]; then
    term_width=$CAP_WIDTH
  else
    term_width=$(tput cols 2>/dev/null || echo 80)
  fi

  max_text_width=$((term_width - 4))
  display_text="$text"

  # Trim if needed
  if (( ${#text} > max_text_width )); then
    display_text="${text:0:max_text_width-3}..."
  fi

  border="${box_char}$(printf '%*s' ${#display_text} '' \
         | tr ' ' "${box_char}")${box_char}"

  printf "%b\n" "${box_color}${border}${clr_default}"
  printf "%b\n" "${box_color}${box_char}${text_color}${display_text}${box_color}${box_char}${clr_default}"
  printf "%b\n" "${box_color}${border}${clr_default}"
}

# ==============================================================================
# boxn:   prints multi-line text inside a colored box
# Usage:  tui_boxn "Hello long world text that wraps nicely" TUI_CLR_BLUE
#         TUI_CLR_WHITE
# ==============================================================================
tui_boxn() {
  local text="$1"
  local box_color="${2:-$'\033[0m'}"
  local text_color="${3:-$'\033[0m'}"
  local box_char="${BOX_CHAR:-#}"
  local clr_default=$'\033[0m'
  local term_width max_line_width word line border padded
  local -a words lines
  local max_len=0

  # Determine box width
  if [[ -n "$CAP_WIDTH" && "$CAP_WIDTH" =~ ^[0-9]+$ ]]; then
    term_width=$CAP_WIDTH
  else
    term_width=$(tput cols 2>/dev/null || echo 80)
  fi

  max_line_width=$((term_width - 4))
  words=($text)
  line=""
  lines=()

  # Split text into lines
  for word in "${words[@]}"; do
    if (( ${#line} + ${#word} + 1 <= max_line_width )); then
      [[ -z "$line" ]] && line="$word" || line="$line $word"
    else
      lines+=("$line")
      line="$word"
    fi
  done
  [[ -n "$line" ]] && lines+=("$line")

  # Determine max line length
  for line in "${lines[@]}"; do
    (( ${#line} > max_len )) && max_len=${#line}
  done

  border="${box_char}$(printf '%*s' "$max_len" '' \
         | tr ' ' "${box_char}")${box_char}"

  printf "%b\n" "${box_color}${border}${clr_default}"
  for line in "${lines[@]}"; do
    padded="$line$(printf '%*s' $((max_len - ${#line})) '')"
    printf "%b\n" "${box_color}${box_char}${text_color}${padded}${box_color}${box_char}${clr_default}"
  done
  printf "%b\n" "${box_color}${border}${clr_default}"
}


# ==============================================================================
# sep: prints a horizontal separator line
# Usage: tui_sep TUI_CLR_BLUE
# ==============================================================================
tui_sep() {
  local color="${1:-$'\033[0m'}"
  local sep_char="${SEP_CHAR:--}"
  local clr_default=$'\033[0m'
  local line_width line

  # Determine line width
  if [[ -n "$CAP_WIDTH" && "$CAP_WIDTH" =~ ^[0-9]+$ ]]; then
    line_width=$CAP_WIDTH
  else
    line_width=$(tput cols 2>/dev/null || echo 80)
  fi

  line=$(printf '%*s' "$line_width" '' | tr ' ' "$sep_char")
  printf "%b\n" "${color}${line}${clr_default}"
}

# ==============================================================================
# tui_prog_bar: prints a simple progress bar
# Usage:        tui_prog_bar 3 10 TUI_CLR_BLUE TUI_CLR_WHITE
# ==============================================================================
tui_prog_bar() {
  local current="$1"
  local total="$2"
  local bar_color="${3:-$'\033[0m'}"
  local text_color="${4:-$'\033[0m'}"
  local prog_char="${PROG_BAR_CHAR:-#}"
  local clr_default=$'\033[0m'
  local term_width x_y reserved bar_width filled empty bar_filled bar_empty

  # Determine available width
  if [[ -n "$CAP_WIDTH" && "$CAP_WIDTH" =~ ^[0-9]+$ ]]; then
    term_width=$CAP_WIDTH
  else
    term_width=$(tput cols 2>/dev/null || echo 80)
  fi

  # Reserve space for brackets, spaces, and "x/y"
  x_y="${current}/${total}"
  reserved=$((4 + ${#x_y}))
  bar_width=$((term_width - reserved))
  ((bar_width < 1)) && bar_width=1

  # Calculate filled part
  filled=$(( current * bar_width / total ))
  empty=$(( bar_width - filled ))
  bar_filled=$(printf '%*s' "$filled" '' | tr ' ' "$prog_char")
  bar_empty=$(printf '%*s' "$empty" '' | tr ' ' ' ')

  printf "\r%b[%b%b] %b%s%b" \
    "$bar_color" "$bar_filled" "$bar_empty" "$text_color" "$x_y" "$clr_default"
}

# ==============================================================================
# tui_spinner: shows a spinner for a background process
# Usage:       tui_spinner $! "Loading data..." TUI_CLR_YELLOW TUI_CLR_CYAN
# ==============================================================================
tui_spinner() {
  local pid="$1"
  local user_text="${2:-Working...}"
  local spin_color="${3:-$'\033[0m'}"
  local text_color="${4:-$'\033[0m'}"
  local clr_default=$'\033[0m'
  local delay=0.1
  local spinstr='|/-\'
  local i=0
  local c

  tput civis 2>/dev/null || true

  while kill -0 "$pid" 2>/dev/null; do
    c="${spinstr:i++%${#spinstr}:1}"
    printf "\r%b[%b%s%b] %b%s%b" \
      "$spin_color" "$text_color" "$c" "$spin_color" "$text_color" \
      "$user_text" "$clr_default"
    sleep "$delay"
  done

  printf "\r%b[%b✓%b] %b%s%b\n" \
    "$spin_color" "$text_color" "$spin_color" "$text_color" "$user_text" \
    "$clr_default"

  tput cnorm 2>/dev/null || true
}

# ==============================================================================
# tui_confirm: ask user yes/no question
# Usage:       tui_confirm "Do you want to continue?" "$TUI_CLR_YELLOW"
# Returns:     true (yes) or false (no)
# ==============================================================================
tui_confirm() {
  local question="$1"
  local color="${2:-$'\033[0m'}"
  local clr_default=$'\033[0m'
  local answer

  while true; do
    printf "%b [y|n]: " "${color}${question}${clr_default}"
    read -r answer
    answer="$(printf '%s' "$answer" | tr '[:upper:]' '[:lower:]')"

    case "$answer" in
      y|yes) return 0 ;;
      n|no)  return 1 ;;
      *) ;;
    esac
  done
}

# ==============================================================================
# tui_choose: show a numbered list and ask user to choose
# Usage:      tui_choose "Select an option:" ARRAY_NAME "$TUI_CLR_CYAN"
#             Selected value is stored in 'selected'
# ==============================================================================
tui_choose() {
  local prompt="$1"
  local array_name="$2"
  local color="${3:-$'\033[0m'}"
  local clr_default=$'\033[0m'
  local choice arr_len i

  eval "arr_len=\${#${array_name}[@]}"
  printf "%b\n" "${color}${prompt}${clr_default}"

  i=0
  eval "for item in \"\${${array_name}[@]}\"; do
          printf \"%b\n\" \"${color} \$((i+1))) \$item${clr_default}\"
          i=\$((i+1))
        done"

  while true; do
    printf "%b" "${color}Enter choice [1-${arr_len}]: ${clr_default}"
    read -r choice </dev/tty

    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= arr_len)); then
      eval "selected=\${${array_name}[choice-1]}"
      return 0
    fi
  done
}