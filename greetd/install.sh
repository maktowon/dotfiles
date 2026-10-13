#!/bin/sh
# Install the Quickshell greeter for greetd. Run as root: sudo ./install.sh
set -eu

here=$(cd "$(dirname "$0")" && pwd)
qs_config="$here/../quickshell/.config/quickshell"

# Keep the stock config the first time around
[ -f /etc/greetd/config.toml.orig ] || cp /etc/greetd/config.toml /etc/greetd/config.toml.orig

# The greeter user can't read $HOME, so it gets its own copy of the config
rm -rf /etc/greetd/quickshell
cp -r "$qs_config" /etc/greetd/quickshell
chown -R root:root /etc/greetd/quickshell
chmod -R u=rwX,go=rX /etc/greetd/quickshell

install -m 644 "$here/hyprland.lua" /etc/greetd/hyprland.lua
install -m 644 "$here/config.toml" /etc/greetd/config.toml

echo "Installed. Enable on next boot with: sudo systemctl enable greetd"
