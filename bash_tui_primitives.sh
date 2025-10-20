#!/usr/bin/env bash

# bash-tui-primitives.sh
# version: 0.0.0

################################################################################
# BASE PRIMITIVES AND VARIABLES SECTION                                        #
# These are obligatory primitives you must include in your script if you are.  #
# copying only certain functions.                                              #
################################################################################

# COLORS
CLR_DEFAULT=$'\033[0m'
CLR_RED=$'\033[0;31m'
CLR_GREEN=$'\033[0;32m'
CLR_YELLOW=$'\033[1;33m'
CLR_BLUE=$'\033[0;34m'
CLR_MAGENTA=$'\033[0;35m'
CLR_CYAN=$'\033[0;36m'
CLR_WHITE=$'\033[1;37m'

# ==============================================================================
# print:  prints text without newline
# Usage:  tui_print "Hello World" CLR_RED
#         Second parameter is optional; defaults to CLR_DEFAULT
# ==============================================================================
tui_print() {
  local text="$1"
  local color="${2:-$CLR_DEFAULT}"

  printf "%b" "${color}${text}${CLR_DEFAULT}"
}

# ==============================================================================
# println: prints text with newline
# Usage:   tui_println "Hello World" CLR_GREEN
#          Second parameter is optional; defaults to CLR_DEFAULT
# ==============================================================================
tui_println() {
  local text="$1"
  local color="${2:-$CLR_DEFAULT}"

  printf "%b\n" "${color}${text}${CLR_DEFAULT}"
}

################################################################################
# EXTRA SETTINGS SECTION                                                       #
# These are extra settings that allow customization, there are not required    #
################################################################################

# Global settings (optional - uncomment to use)
#CAP_WIDTH=80 # Will limit tui components to a certain width.

# Character settings (optional - uncomment and modify to override defaults)
#BOX_CHAR="#"      # Default char the box is made of (default: #)
#SEP_CHAR="-"      # Default char the separator is made of (default: -)
#PROG_BAR_CHAR="#" # Default char the progress bar is made of (default: #)

################################################################################
# TUI ELEMENT SECTION                                                          #
# These section contain various TUI elements. Each element is self-contained   #
# meaning, you can copy any of them to your script and they should work as     #
# long as you copied base primitives and variables.
################################################################################

# ==============================================================================
# print_ok: prints text in green
# Usage:    tui_print_ok "OK"
# Source:   bash-tui-primitives by Timax
#           github.com/dancesWithMachines/bash-tui-primitives
# ==============================================================================
tui_print_ok() {
  tui_print "$1" "$CLR_GREEN"
}

# ==============================================================================
# print_warn: prints text in yellow
# Usage:      tui_print_warn "WARN"
# ==============================================================================
tui_print_warn() {
  tui_print "$1" "$CLR_YELLOW"
}

# ==============================================================================
# print_err: prints text in red
# Usage:     tui_print_err "ERROR"
# ==============================================================================
tui_print_err() {
  tui_print "$1" "$CLR_RED"
}

# ==============================================================================
# println_ok: prints text in green with newline
# Usage:    tui_println_ok "OK"
# ==============================================================================
tui_println_ok() {
  tui_println "$1" "$CLR_GREEN"
}

# ==============================================================================
# println_warn: prints text in yellow with newline
# Usage:    tui_println_warn "WARN"
# ==============================================================================
tui_println_warn() {
  tui_println "$1" "$CLR_YELLOW"
}

# ==============================================================================
# println_err: prints text in red with newline
# Usage:    tui_println_err "ERROR"
# ==============================================================================
tui_println_err() {
  tui_println "$1" "$CLR_RED"
}

# ==============================================================================
# box:    prints single-line text inside a colored box
# Usage:  tui_box "Hello World" CLR_BLUE CLR_WHITE
# ==============================================================================
tui_box() {
  local text="$1"
  local box_color="${2:-$CLR_DEFAULT}"
  local text_color="${3:-$CLR_DEFAULT}"
  local box_char="${BOX_CHAR:-#}"
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

  border="${box_char}$(printf '%*s' ${#display_text} '' | tr ' ' "${box_char}")${box_char}"

  printf "%b\n" "${box_color}${border}${CLR_DEFAULT}"
  printf "%b\n" "${box_color}${box_char}${text_color}${display_text}${box_color}${box_char}${CLR_DEFAULT}"
  printf "%b\n" "${box_color}${border}${CLR_DEFAULT}"
}

# ==============================================================================
# boxn:   prints multi-line text inside a colored box
# Usage:  tui_boxn "Hello long world text that wraps nicely" CLR_BLUE CLR_WHITE
# ==============================================================================
tui_boxn() {
  local text="$1"
  local box_color="${2:-$CLR_DEFAULT}"
  local text_color="${3:-$CLR_DEFAULT}"
  local box_char="${BOX_CHAR:-#}"
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

  border="${box_char}$(printf '%*s' "$max_len" '' | tr ' ' "${box_char}")${box_char}"

  printf "%b\n" "${box_color}${border}${CLR_DEFAULT}"
  for line in "${lines[@]}"; do
    padded="$line$(printf '%*s' $((max_len - ${#line})) '')"
    printf "%b\n" "${box_color}${box_char}${text_color}${padded}${box_color}${box_char}${CLR_DEFAULT}"
  done
  printf "%b\n" "${box_color}${border}${CLR_DEFAULT}"
}

# ==============================================================================
# sep: prints a horizontal separator line
# Usage: tui_sep CLR_BLUE
# ==============================================================================
tui_sep() {
  local color="${1:-$CLR_DEFAULT}"
  local sep_char="${SEP_CHAR:--}"
  local line_width line

  # Determine line width
  if [[ -n "$CAP_WIDTH" && "$CAP_WIDTH" =~ ^[0-9]+$ ]]; then
    line_width=$CAP_WIDTH
  else
    line_width=$(tput cols 2>/dev/null || echo 80)
  fi

  line=$(printf '%*s' "$line_width" '' | tr ' ' "$sep_char")
  tui_println "$line" "$color"
}

# ==============================================================================
# tui_prog_bar: prints a simple progress bar
# Usage:        tui_prog_bar 3 10 CLR_BLUE CLR_WHITE
# ==============================================================================
tui_prog_bar() {
  local current="$1"
  local total="$2"
  local bar_color="${3:-$CLR_DEFAULT}"
  local text_color="${4:-$CLR_DEFAULT}"
  local prog_char="${PROG_BAR_CHAR:-#}"
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
    "$bar_color" "$bar_filled" "$bar_empty" "$text_color" "$x_y" "$CLR_DEFAULT"
}

# ==============================================================================
# tui_spinner: shows a spinner for a background process
# Usage:       tui_spinner $! "Loading data..." CLR_YELLOW CLR_CYAN
# ==============================================================================
tui_spinner() {
  local pid="$1"
  local user_text="${2:-Working...}"
  local spin_color="${3:-$CLR_DEFAULT}"
  local text_color="${4:-$CLR_DEFAULT}"
  local delay=0.1
  local spinstr='|/-\'
  local i=0
  local c

  tput civis 2>/dev/null || true

  while kill -0 "$pid" 2>/dev/null; do
    c="${spinstr:i++%${#spinstr}:1}"
    printf "\r%b[%b%s%b] %b%s%b" \
      "$spin_color" "$text_color" "$c" "$spin_color" "$text_color" "$user_text" "$CLR_DEFAULT"
    sleep "$delay"
  done

  printf "\r%b[%b✓%b] %b%s%b\n" \
    "$spin_color" "$text_color" "$spin_color" "$text_color" "$user_text" "$CLR_DEFAULT"

  tput cnorm 2>/dev/null || true
}

# ==============================================================================
# tui_confirm: ask user yes/no question
# Usage:       tui_confirm "Do you want to continue?" "$CLR_YELLOW"
# Returns:     true (yes) or false (no)
# ==============================================================================
tui_confirm() {
  local question="$1"
  local color="${2:-$CLR_DEFAULT}"
  local answer

  while true; do
    printf "%b [y|n]: " "${color}${question}${CLR_DEFAULT}"
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
# Usage:      tui_choose "Select an option:" ARRAY_NAME "$CLR_CYAN"
#             Selected value is stored in 'selected'
# ==============================================================================
tui_choose() {
  local prompt="$1"
  local array_name="$2"
  local color="${3:-$CLR_DEFAULT}"
  local choice arr_len i

  eval "arr_len=\${#${array_name}[@]}"
  tui_println "${prompt}" "${color}"

  i=0
  eval "for item in \"\${${array_name}[@]}\"; do
          tui_println \" \$((i+1))) \$item\" \"\$color\"
          i=\$((i+1))
        done"

  while true; do
    tui_print "Enter choice [1-${arr_len}]: " "${color}"
    read -r choice </dev/tty

    if [[ "$choice" =~ ^[0-9]+$ ]] && ((choice >= 1 && choice <= arr_len)); then
      eval "selected=\${${array_name}[choice-1]}"
      return 0
    fi
  done
}