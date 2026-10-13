-- autostart.lua

local programs = require("modules.programs")

hl.on("hyprland.start", function ()
  hl.exec_cmd(programs.terminal)
  hl.exec_cmd(programs.desktopShell)
end)
