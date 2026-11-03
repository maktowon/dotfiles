-- keybinds.lua

local programs = require("modules.programs")
local mainMod = "ALT"

-- quit hyprland
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- lock
hl.bind(mainMod .. " + CTRL + L", hl.dsp.exec_cmd("qs ipc call lock lock"))

-- terminal
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd(programs.terminal))

-- file explorer
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(programs.fileManager))

-- app launcher
hl.bind(mainMod .. " + SPACE", hl.dsp.exec_cmd(programs.menu))

-- close window; WezTerm gets the key instead and kills the window's session (see wezterm.lua)
hl.bind(mainMod .. " + Q", function()
    local w = hl.get_window("activewindow")
    if w and w.class == "org.wezfurlong.wezterm" then
        hl.dispatch(hl.dsp.send_shortcut({ mods = mainMod, key = "q", window = "activewindow" }))
    else
        hl.dispatch(hl.dsp.window.close())
    end
end)

-- fullscreen
hl.bind(mainMod .. " + F",  hl.dsp.window.fullscreen({ mode = "maximized" }))
hl.bind(mainMod .. " + SHIFT + F",  hl.dsp.window.fullscreen({ mode = "fullscreen" }))

-- move focus; in WezTerm, pass the key through while it has a pane in that direction
-- (WezTerm moves between panes on Alt+h/j/k/l, see wezterm.lua)
local function wezterm_has_pane(pid, direction)
    local f = io.popen(("WEZTERM_UNIX_SOCKET=$XDG_RUNTIME_DIR/wezterm/gui-sock-%d wezterm cli --no-auto-start get-pane-direction %s 2>/dev/null"):format(pid, direction))
    local out = f:read("*a")
    f:close()
    return out:match("%d") ~= nil
end

-- a passed key press makes Hyprland call the bind again on release; pass that too
local passing = false

local function focus(direction)
    return function()
        local w = hl.get_window("activewindow")
        if passing or (w and w.class == "org.wezfurlong.wezterm" and wezterm_has_pane(w.pid, direction)) then
            passing = not passing
            hl.dispatch(hl.dsp.pass({ window = "activewindow" }))
        else
            hl.dispatch(hl.dsp.focus({ direction = direction }))
        end
    end
end
hl.bind(mainMod .. " + H",  focus("left"))
hl.bind(mainMod .. " + L",  focus("right"))
hl.bind(mainMod .. " + K",  focus("up"))
hl.bind(mainMod .. " + J",  focus("down"))

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

-- screenshots (select area): Print copies to clipboard, Shift+Print saves to ~/screenshots
hl.bind("Print",         hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | wl-copy --type image/png"))
hl.bind("SHIFT + Print", hl.dsp.exec_cmd("mkdir -p ~/screenshots && grim -g \"$(slurp)\" ~/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png"))

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
