#!/usr/bin/env bash

# Rofi Smart Run Script (open url in browser with rofi
# Author: Binoy Manoj
# GitHub: https://github.com/binoymanoj

# Usage:
# - Normal search: "linux tutorial" → DuckDuckGo (default)
# - Google search: "linux tutorial :g" → Google
# - DuckDuckGo search: "linux tutorial :d" → DuckDuckGo

browser="firefox"   # change to firefox, chromium, etc.

  # Show menu items and let user freely type or select an item.
  # -i case-insensitive, -p prompt, -mesg shows instructions above.
input="$(printf '%s\n' "$menu" | rofi -dmenu -i -p "Lookup Nix pkgs:")"

# Trim leading/trailing whitespace
input="$(echo -e "$input" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')"

# Exit if empty (user cancelled)
[ -z "$input" ] && exit 0

# Helper to open URL in background cleanly
open_in_browser() {
  url="$1"
  # use setsid so it detaches from rofi; redirect output to /dev/null
  setsid "$browser" "$url" >/dev/null 2>&1 &
  disown
}

# No token present: fallback default search (DuckDuckGo)
q="$(echo "$input" | sed 's/ /+/g')"
open_in_browser "https://search.nixos.org/packages?channel=unstable&query=$q"
exit 0