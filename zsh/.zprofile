# Start Hyprland on tty1 (autologin via getty); Quickshell locks the session right away.
# The loop waits for Quickshell, which autostart.lua launches at the same time.
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
    exec start-hyprland -- --locked-cmd "sh -c 'until qs ipc call lock lock; do sleep 0.1; done'"
fi
