#!/bin/sh
# Install tty1 autologin. Run as root: sudo ./install.sh
set -eu

here=$(cd "$(dirname "$0")" && pwd)

install -Dm 644 "$here/override.conf" /etc/systemd/system/getty@tty1.service.d/override.conf
systemctl daemon-reload

echo "Installed."
