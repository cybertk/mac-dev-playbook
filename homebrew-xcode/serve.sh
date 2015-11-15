#!/bin/bash

# Serve Xcode Formulae

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PORT=8080

# en1 is the host-only interface
vm_ip=$(vagrant ssh -c "ifconfig en1" -- -q | /usr/bin/grep "inet[^6]" | awk '{print $2}')
host_ip=${vm_ip%.*}.1

formula="$SCRIPT_DIR/xcode.rb"
echo "== Generating Homebrew formula of Xcode to $formula"
sed -e "s/<%= hostName %>/$host_ip:$PORT/" "$SCRIPT_DIR/xcode.rb.template" > "$formula"
cd "$SCRIPT_DIR" && python3 -m http.server --bind "$host_ip" "$PORT"
