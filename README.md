# bash_tui_primitives.sh

`bash_tui_primitives.sh` is a set of simple TUI primitives in form of a single bash script.

It aims to solve a common problem: whenever I want to add more advanced printing or user prompts to
a Bash script, I end up rewriting them from scratch. Not anymore...

## What can it do

Draw:
* boxes
* progress bars
* spinners
* separators

User prompts:
* colored text
* "y/n" dialogs
* multiple choice prompts

## Self-contained

All the functions are self-contained and complete. This means you can copy any of the functions to
your codebase, and it should work without any dependencies. You can copy functions individually or
even load entire set dynamically as shown in following example.

```bash
wget -q -O /tmp/bash_tui_primitives.sh https://raw.githubusercontent.com/dancesWithMachines/bash_tui_primitives/refs/heads/main/bash_tui_primitives.sh
source /tmp/bash_tui_primitives.sh
tui_box "Hello World!"
```

Here's a bit more robust example. It fetches the script by tag to ensure it always stays the same
and performs checksum verification.

```bash
wget -q -O /tmp/bash_tui_primitives.sh https://raw.githubusercontent.com/dancesWithMachines/bash_tui_primitives/refs/tags/v0.0.1/bash_tui_primitives.sh
if [ "$(md5sum /tmp/bash_tui_primitives.sh | awk '{print $1}')" != "24ff49d8bc17a18ec30ad41558de0f19" ]; then
    exit 1
else
    source /tmp/bash_tui_primitives.sh
    tui_box "Hello World!"
fi
```

## Test

Run `test.sh` script for a simple demo.

## License

The code is in public domain, you can use the code freely without any attribution. Refer to
`LICENSE` file for details.