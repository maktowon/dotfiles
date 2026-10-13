-- keybinds.lua

local programs = require("modules.programs")
local mainMod = "ALT"

-- quit hyprland
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- lock
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("qs ipc call lock lock"))

-- terminal
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(programs.terminal))

-- app launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(programs.menu))

-- close window
hl.bind(mainMod .. " + Q", hl.dsp.window.close())

-- fullscreen
hl.bind(mainMod .. " + F",  hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F",  hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- move focus
hl.bind(mainMod .. " + H",  hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L",  hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K",  hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J",  hl.dsp.focus({ direction = "down" }))

-- swap windows
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.swap({ direction = "down" }))

-- move windows
hl.bind(mainMod .. " + SHIFT + CTRL + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + CTRL + L", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + CTRL + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + CTRL + J", hl.dsp.window.move({ direction = "down" }))

-- rotate split clockwise (dwindle only)
hl.bind(mainMod .. " + R", hl.dsp.layout("rotatesplit 90"))

-- workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,             hl.dsp.focus({ workspace = i}))
    hl.bind(mainMod .. " + SHIFT + " .. key,     hl.dsp.window.move({ workspace = i, follow = false }))
end

-- multimedia
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 1%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 1%-"),      { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"),     { locked = true, repeating = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"),   { locked = true, repeating = true })

-- player
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })
