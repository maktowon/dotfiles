local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

config.color_scheme = 'nord'

config.font = wezterm.font 'JetBrains Mono Nerd Font Mono'
config.font_size = 14

config.enable_tab_bar = false

-- sessions: run everything inside a mux server so workspaces survive closing the window
config.unix_domains = { { name = 'unix' } }
config.default_gui_startup_args = { 'connect', 'unix' }

-- every newly opened window starts in its own new session (random name)
wezterm.on('gui-attached', function()
  for _, window in ipairs(wezterm.gui.gui_windows()) do
    window:perform_action(
      act.SwitchToWorkspace { spawn = { domain = { DomainName = 'unix' } } },
      window:active_pane()
    )
  end
end)

-- kill every pane in the given session, in the background after `delay` seconds
local function kill_workspace(name, delay)
  local ok, stdout = wezterm.run_child_process { 'wezterm', 'cli', '--prefer-mux', 'list', '--format', 'json' }
  if not ok then
    return
  end
  local cmd = { 'sh', '-c', 'sleep "$0"; for id; do wezterm cli --prefer-mux --no-auto-start kill-pane --pane-id "$id"; done', tostring(delay) }
  for _, p in ipairs(wezterm.serde.json_decode(stdout)) do
    if p.workspace == name then
      table.insert(cmd, tostring(p.pane_id))
    end
  end
  wezterm.background_child_process(cmd)
end

-- kill every pane in the current session after switching to another one
local function kill_session(window, pane)
  local current = window:active_workspace()

  local target
  for _, name in ipairs(wezterm.mux.get_workspace_names()) do
    if name ~= current then
      target = name
      break
    end
  end
  if not target then
    if current == 'default' then
      window:toast_notification('wezterm', 'Cannot kill the only session', nil, 3000)
      return
    end
    target = 'default'
  end

  window:perform_action(act.SwitchToWorkspace { name = target }, pane)
  kill_workspace(current, 0)
end

config.leader ={ key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

config.keys = {
  -- send a literal Ctrl+a (leader, Ctrl+a)
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

  -- splits, vim semantics: h = :split (stacked), v = :vsplit (side by side)
  { key = 'h', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- maximize/restore current pane
  { key = 'f', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- close current pane (only asks if something other than the shell is running)
  { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- pane navigation; Hyprland only passes these through when a pane exists in
  -- that direction, otherwise it moves to the next window (see keybinds.lua)
  { key = 'h', mods = 'ALT', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'ALT', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'ALT', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'ALT', action = act.ActivatePaneDirection 'Right' },

  -- pane navigation
  { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection 'Right' },

  -- sessions (workspaces)
  { key = 's', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|WORKSPACES' } },
  { key = 'Q', mods = 'LEADER|SHIFT', action = wezterm.action_callback(kill_session) },
  -- Alt+q (sent by Hyprland's close-window bind): close this window and kill its session;
  -- the window must go first, otherwise WezTerm switches it to another session
  {
    key = 'q',
    mods = 'ALT',
    action = wezterm.action_callback(function(window, pane)
      kill_workspace(window:active_workspace(), 0.3)
      window:perform_action(act.QuitApplication, pane)
    end),
  },
  {
    key = 'n',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'New session name:',
      action = wezterm.action_callback(function(window, pane, line)
        if line and line ~= '' then
          window:perform_action(act.SwitchToWorkspace { name = line }, pane)
        end
      end),
    },
  },
}

return config
