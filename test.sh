#!/usr/bin/env bash

# Source the TUI library
source ./bash_tui_primitives.sh

declare -i test_num=1

echo "=========================================="
echo "  Bash TUI Primitives - Test Suite"
echo "=========================================="
echo ""

# Basic print functions
echo "TEST $test_num: tui_print (no newline)"
tui_print "This is printed without newline... "
tui_print "and this continues on same line"
echo ""
echo ""
((test_num++))

# Basic println functions
echo "TEST $test_num: tui_println (with newline)"
tui_println "This is printed with newline"
tui_println "This is on a new line"
echo ""
((test_num++))

# Colored print
echo "TEST $test_num: tui_print with colors"
tui_print "Red text " "$TUI_CLR_RED"
tui_print "Green text " "$TUI_CLR_GREEN"
tui_print "Blue text" "$TUI_CLR_BLUE"
echo ""
echo ""
((test_num++))

# Colored println
echo "TEST $test_num: tui_println with colors"
tui_println "Yellow line" "$TUI_CLR_YELLOW"
tui_println "Cyan line" "$TUI_CLR_CYAN"
tui_println "Magenta line" "$TUI_CLR_MAGENTA"
echo ""
((test_num++))

# OK/WARN/ERR variants
echo "TEST $test_num: tui_print_ok, tui_print_warn, tui_print_err"
tui_print_ok "[OK] "
tui_print_warn "[WARN] "
tui_print_err "[ERROR]"
echo ""
((test_num++))

# OK/WARN/ERR variants
echo "TEST $test_num: Combined, colored tui_print_... + tui_println_... with no params."
tui_print_ok
tui_print_warn
tui_print_err
echo ""
tui_println_ok
tui_println_warn
tui_println_err
echo ""
echo ""
((test_num++))

echo "TEST $test_num: tui_println_ok, tui_println_warn, tui_println_err"
tui_println_ok "[OK] Operation successful"
tui_println_warn "[WARN] This is a warning"
tui_println_err "[ERROR] This is an error"
echo ""
((test_num++))

# Single-line box
echo "TEST $test_num: tui_box (single-line box)"
tui_box "This is a simple box" "$TUI_CLR_BLUE" "$TUI_CLR_WHITE"
echo ""
((test_num++))

echo "TEST $test_num: tui_box with different colors"
tui_box "Success message in a box" "$TUI_CLR_GREEN" "$TUI_CLR_RED"
echo ""
((test_num++))

# Multi-line box
echo "TEST $test_num: tui_boxn (multi-line box with text wrapping)"
tui_boxn "This is a longer text that will wrap into multiple lines inside the box. It demonstrates the tui_boxn function which automatically handles text wrapping based on terminal width." "$TUI_CLR_CYAN" "$TUI_CLR_WHITE"
echo ""
((test_num++))

# Separator
echo "TEST $test_num: tui_sep (horizontal separator)"
tui_sep "$TUI_CLR_BLUE"
echo "Text between separators"
tui_sep "$TUI_CLR_GREEN"
echo ""
((test_num++))

# Progress bar
echo "TEST $test_num: tui_prog_bar (progress bar)"
for i in {0..10}; do
  tui_prog_bar $i 10 "$TUI_CLR_GREEN" "$TUI_CLR_WHITE"
  sleep 0.2
done
echo ""
echo ""
((test_num++))

# Spinner
echo "TEST $test_num: tui_spinner (spinner for background process)"
(sleep 3) &
tui_spinner $! "Processing data" "$TUI_CLR_YELLOW" "$TUI_CLR_CYAN"
echo ""
((test_num++))

# Confirm dialog
echo "TEST $test_num: tui_confirm (yes/no question)"
if tui_confirm "Do you want to continue with the test?" "$TUI_CLR_YELLOW"; then
  tui_println_ok "User selected: YES"
else
  tui_println_err "User selected: NO"
fi
echo ""
((test_num++))

# Choose from list
echo "TEST $test_num: tui_choose (select from list)"
options=("Option One" "Option Two" "Option Three" "Option Four")
tui_choose "Please select an option:" options "$TUI_CLR_CYAN"
tui_println_ok "You selected: $selected"
echo ""
((test_num++))

# Combined example
echo "TEST $test_num: Combined example - simulated installation"
tui_sep "$TUI_CLR_BLUE"
tui_boxn "Installation Wizard - This will install the application on your system" "$TUI_CLR_BLUE" "$TUI_CLR_WHITE"

tui_print "Checking system requirements... "
sleep 1
tui_println_ok "[OK]"

tui_print "Downloading packages... "
sleep 1
tui_println_ok "[OK]"

tui_println "Installing components:" "$TUI_CLR_CYAN"
for i in {1..5}; do
  tui_prog_bar $i 5 "$TUI_CLR_GREEN" "$TUI_CLR_WHITE"
  sleep 0.3
done
echo ""

(sleep 2) &
tui_spinner $! "Configuring system" "$TUI_CLR_YELLOW" "$TUI_CLR_WHITE"

tui_box "Installation Complete!" "$TUI_CLR_GREEN" "$TUI_CLR_WHITE"
tui_sep "$TUI_CLR_GREEN"
echo ""

echo "=========================================="
echo "  All tests completed!"
echo "=========================================="