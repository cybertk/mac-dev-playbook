#!/bin/bash

# Serve Xcode Formulae

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PORT=8080
XCODE_VERSION=7.1

# en1 is the host-only interface
echo "== Getting vm ip"
vm_ip=$(vagrant ssh -c "ifconfig en1" -- -q | /usr/bin/grep "inet[^6]" | awk '{print $2}')
host_ip=${vm_ip%.*}.1

xcode="$SCRIPT_DIR/Xcode_$XCODE_VERSION.dmg"

# Ensure xcode is downloaded
if [ ! -f "$xcode" ];
then
    echo "== error: No Xcode.dmg found, download at http://stackoverflow.com/a/10335943/622662"
    exit 1
fi

# Calculating checksum
if [ ! -f "$xcode.checksum" ];
then
    echo "== Calculating checksum of $xcode"
    shasum -a 256 "$xcode" | awk '{print $1}' > "$xcode.checksum"
fi
xcode_checksum=$(cat "$xcode.checksum")

formula="$SCRIPT_DIR/xcode.rb"
echo "== Generating Homebrew formula of Xcode to $formula"
sed -e "s/<%= hostName %>/$host_ip:$PORT/" \
    -e "s/<%= xcodeVersion %>/$XCODE_VERSION/" \
    -e "s/<%= xcodeChecksum %>/$xcode_checksum/" \
    "$SCRIPT_DIR/xcode.rb.template" > "$formula"

# Serve
cd "$SCRIPT_DIR" && python3 -m http.server --bind "$host_ip" "$PORT"
