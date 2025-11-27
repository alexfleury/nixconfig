#!/usr/bin/env bash
# This script is designed to be used with rofi to facilitate web searches. It
# takes a search query as input, opens the query in a web browser using
# xdg-open, and maintains a history of recent searches. The script relies on
# placeholder variables `@history_file@` and `@base_url@` which should be
# replaced with the actual path to the history file and the base URL for the
# search engine, respectively.

history_file="@history_file@"
base_url="@base_url@"

if [ $# -gt 0 ]; then
    query=$(echo "$1" | xargs)
fi

# If the history file does not exist, create it.
if ! [ -e "$history_file" ] && [ $# -gt 0 ]; then
    echo "$query" >> "$history_file"
# If the file exists, and we provided an argument,
# prepend the argument to the history file.
elif [ -e "$history_file" ] && [ $# -gt 0 ]; then
    sed -i "1s/^/$query\n/" "$history_file"
fi

# Launch.
if [ $# -gt 0 ]; then
    coproc { xdg-open "$base_url$query" > /dev/null  2>&1; }
    exit 0
fi

if [ -e "$history_file" ]; then
    # Remove last empty line.
    awk -i inplace "NF" "$history_file"
    # Keep only 20 lines in history.
    sed -i "21,$ d" "$history_file"
    # Remove doublons in history.
    awk -i inplace '!seen[$0]++' "$history_file"

    # Print history.
    while read -r p; do
    echo "$p"
    done <"$history_file"
fi

exit 0