-- autostart.lua

local programs = require("modules.programs")

hl.on("hyprland.start", function ()
  hl.exec_cmd("gsettings set org.gnome.desktop.interface gtk-theme Nordic")
  hl.exec_cmd("gsettings set org.gnome.desktop.interface color-scheme prefer-dark")
  hl.exec_cmd(programs.terminal)
  hl.exec_cmd(programs.desktopShell)
end)
