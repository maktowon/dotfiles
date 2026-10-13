-- Minimal Hyprland that only hosts the Quickshell greeter.
-- Installed to /etc/greetd/hyprland.lua by install.sh

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.config({
    misc = {
        force_default_wallpaper  = 0,
        disable_hyprland_logo    = true,
        disable_splash_rendering = true,
    },
    input = {
        kb_layout  = "us",
        kb_options = "caps:alt_caps_lock",
    },
    animations = {
        enabled = false,
    },
})

-- Greeter exits after handing the session to greetd; take the compositor down with it
hl.on("hyprland.start", function ()
  hl.exec_cmd("qs -p /etc/greetd/quickshell/greeter.qml; hyprctl dispatch 'hl.dsp.exit()'")
end)
