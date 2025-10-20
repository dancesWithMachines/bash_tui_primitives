#!/usr/bin/env bash

# Source the TUI library
source ./bash_tui_primitives.sh

echo "=========================================="
echo "  Bash TUI Primitives - Test Suite"
echo "=========================================="
echo ""

# Test 1: Basic print functions
echo "TEST 1: tui_print (no newline)"
tui_print "This is printed without newline... "
tui_print "and this continues on same line"
echo ""
echo ""

# Test 2: Basic println functions
echo "TEST 2: tui_println (with newline)"
tui_println "This is printed with newline"
tui_println "This is on a new line"
echo ""

# Test 3: Colored print
echo "TEST 3: tui_print with colors"
tui_print "Red text " "$CLR_RED"
tui_print "Green text " "$CLR_GREEN"
tui_print "Blue text" "$CLR_BLUE"
echo ""
echo ""

# Test 4: Colored println
echo "TEST 4: tui_println with colors"
tui_println "Yellow line" "$CLR_YELLOW"
tui_println "Cyan line" "$CLR_CYAN"
tui_println "Magenta line" "$CLR_MAGENTA"
echo ""

# Test 5: OK/WARN/ERR variants
echo "TEST 5: tui_print_ok, tui_print_warn, tui_print_err"
tui_print_ok "[OK] "
tui_print_warn "[WARN] "
tui_print_err "[ERROR]"
echo ""
echo ""

echo "TEST 6: tui_println_ok, tui_println_warn, tui_println_err"
tui_println_ok "[OK] Operation successful"
tui_println_warn "[WARN] This is a warning"
tui_println_err "[ERROR] This is an error"
echo ""

# Test 7: Single-line box
echo "TEST 7: tui_box (single-line box)"
tui_box "This is a simple box" "$CLR_BLUE" "$CLR_WHITE"
echo ""

echo "TEST 8: tui_box with different colors"
tui_box "Success message in a box" "$CLR_GREEN" "$CLR_RED"
echo ""

# Test 9: Multi-line box
echo "TEST 9: tui_boxn (multi-line box with text wrapping)"
tui_boxn "This is a longer text that will wrap into multiple lines inside the box. It demonstrates the tui_boxn function which automatically handles text wrapping based on terminal width." "$CLR_CYAN" "$CLR_WHITE"
echo ""

# Test 10: Separator
echo "TEST 10: tui_sep (horizontal separator)"
tui_sep "$CLR_BLUE"
echo "Text between separators"
tui_sep "$CLR_GREEN"
echo ""

# Test 11: Progress bar
echo "TEST 11: tui_prog_bar (progress bar)"
for i in {0..10}; do
  tui_prog_bar $i 10 "$CLR_GREEN" "$CLR_WHITE"
  sleep 0.2
done
echo ""
echo ""

# Test 12: Spinner
echo "TEST 12: tui_spinner (spinner for background process)"
(sleep 3) &
tui_spinner $! "Processing data" "$CLR_YELLOW" "$CLR_CYAN"
echo ""

# Test 13: Confirm dialog
echo "TEST 13: tui_confirm (yes/no question)"
if tui_confirm "Do you want to continue with the test?" "$CLR_YELLOW"; then
  tui_println_ok "User selected: YES"
else
  tui_println_err "User selected: NO"
fi
echo ""

# Test 14: Choose from list
echo "TEST 14: tui_choose (select from list)"
options=("Option One" "Option Two" "Option Three" "Option Four")
tui_choose "Please select an option:" options "$CLR_CYAN"
tui_println_ok "You selected: $selected"
echo ""

# Test 15: Combined example
echo "TEST 15: Combined example - simulated installation"
tui_sep "$CLR_BLUE"
tui_boxn "Installation Wizard - This will install the application on your system" "$CLR_BLUE" "$CLR_WHITE"
tui_sep "$CLR_BLUE"

tui_print "Checking system requirements... "
sleep 1
tui_println_ok "[OK]"

tui_print "Downloading packages... "
sleep 1
tui_println_ok "[OK]"

tui_println "Installing components:" "$CLR_CYAN"
for i in {1..5}; do
  tui_prog_bar $i 5 "$CLR_GREEN" "$CLR_WHITE"
  sleep 0.3
done
echo ""

(sleep 2) &
tui_spinner $! "Configuring system" "$CLR_YELLOW" "$CLR_WHITE"

tui_sep "$CLR_GREEN"
tui_box "Installation Complete!" "$CLR_GREEN" "$CLR_WHITE"
tui_sep "$CLR_GREEN"
echo ""

echo "=========================================="
echo "  All tests completed!"
echo "=========================================="