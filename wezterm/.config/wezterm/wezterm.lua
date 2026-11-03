local wezterm = require 'wezterm'
local act = wezterm.action
local config = wezterm.config_builder()

-- saves/restores workspace layouts to disk so they survive a reboot
-- (loaded with pcall so a failed download doesn't take the whole config down)
local ok, resurrect = pcall(wezterm.plugin.require, 'https://github.com/MLFlexer/resurrect.wezterm')
if not ok then
  wezterm.log_error('resurrect.wezterm failed to load: ' .. tostring(resurrect))
  resurrect = nil
end

config.color_scheme = 'nord'

config.font = wezterm.font 'JetBrains Mono Nerd Font Mono'
config.font_size = 14

config.scrollback_lines = 10000

-- updates come from pacman
config.check_for_updates = false

-- fade panes that don't have focus
config.inactive_pane_hsb = { saturation = 0.85, brightness = 1.0 }

-- keep sessions alive in a background mux server; closing the window just detaches
config.unix_domains = { { name = 'unix' } }
-- closing only detaches, so there's nothing to confirm
config.window_close_confirmation = 'NeverPrompt'

-- ssh: remote servers as domains (uncomment and add a matching Host in ~/.ssh/config)
-- connect with `leader c`, or from a shell: `wezterm connect example_server`
-- config.ssh_domains = {
--   {
--     name = 'example_server',
--     -- Host alias from ~/.ssh/config (user, port and key come from there)
--     remote_address = 'example_server',
--     -- 'WezTerm': persistent sessions that survive disconnects; needs the same
--     --            wezterm version installed on the server
--     -- 'None':    plain ssh, nothing to install; splits still open on the server
--     multiplexing = 'WezTerm',
--     -- lets new splits open in the same remote directory
--     assume_shell = 'Posix',
--   },
-- }
-- or instead of listing servers by hand, make a domain for every Host in ~/.ssh/config:
-- config.ssh_domains = wezterm.default_ssh_domains()

-- every launch starts in a fresh session with a random 4-letter name; old ones stay
-- reachable with leader s, rename with leader r
local function random_name()
  local name = ''
  for _ = 1, 4 do name = name .. string.char(math.random(97, 122)) end
  return name
end
config.default_gui_startup_args = { 'connect', '--workspace', random_name(), 'unix' }

-- save every workspace to disk every 5 minutes
if resurrect then
  resurrect.state_manager.periodic_save { interval_seconds = 300, save_workspaces = true }
end

-- minimal bar: no tabs, just "workspace:pane" in the middle
config.enable_tab_bar = true
config.use_fancy_tab_bar = false
config.show_tabs_in_tab_bar = false
config.show_new_tab_button_in_tab_bar = false

-- nord palette
local nord = {
  bar = '#81a1c1',    -- nord9, same as the path segment in omp
  leader = '#ebcb8b', -- nord13, bar color while the leader is waiting for a key
  fg = '#2e3440',     -- nord0
}

config.colors = {
  tab_bar = { background = nord.bar },
}

-- centered "workspace:pane" label, e.g. "default:2"
-- (the bar only has left/right slots, so the left one is padded to fill the whole width)
wezterm.on('update-status', function(window, _)
  local tab = window:active_tab()
  local pane_no = 1
  for _, p in ipairs(tab:panes_with_info()) do
    if p.is_active then pane_no = p.index + 1 end
  end

  local label = ' ' .. window:active_workspace() .. ':' .. pane_no .. ' '
  local cols = tab:get_size().cols
  local left = math.max(0, math.floor((cols - wezterm.column_width(label)) / 2))
  local right = math.max(0, cols - left - wezterm.column_width(label))

  window:set_left_status(wezterm.format {
    { Background = { Color = window:leader_is_active() and nord.leader or nord.bar } },
    { Foreground = { Color = nord.fg } },
    { Attribute = { Intensity = 'Bold' } },
    { Text = string.rep(' ', left) .. label .. string.rep(' ', right) },
  })
end)

-- clickable links: the defaults (urls etc.) plus absolute file paths and github refs
config.hyperlink_rules = wezterm.default_hyperlink_rules()
-- /some/absolute/path -> opens with xdg-open
table.insert(config.hyperlink_rules, {
  regex = [[(?:^|\s)(/(?:[\w.@+-]+/)*[\w.@+-]+)]],
  format = 'file://$1',
  highlight = 1,
})
-- owner/repo#123 -> github issue/pr
table.insert(config.hyperlink_rules, {
  regex = [[\b([\w.-]+)/([\w.-]+)#(\d+)\b]],
  format = 'https://github.com/$1/$2/issues/$3',
})

-- selecting with the mouse copies to the clipboard; a plain click on a link opens it
config.mouse_bindings = {
  {
    event = { Up = { streak = 1, button = 'Left' } },
    mods = 'NONE',
    action = act.CompleteSelectionOrOpenLinkAtMouseCursor 'ClipboardAndPrimarySelection',
  },
}

-- git repos directly in ~ or one level deeper, for the project picker
local function project_choices()
  local home = wezterm.home_dir
  local choices = {}
  for _, pattern in ipairs { home .. '/*/.git', home .. '/*/*/.git' } do
    for _, git_dir in ipairs(wezterm.glob(pattern)) do
      local dir = git_dir:sub(1, -#'/.git' - 1)
      table.insert(choices, { id = dir, label = '~' .. dir:sub(#home + 1) })
    end
  end
  return choices
end

-- session menu (sessions.sh, fzf): o = open, d = delete without closing the menu.
-- it asks for a switch by setting the switch_workspace user var
wezterm.on('user-var-changed', function(window, pane, name, value)
  if name == 'switch_workspace' then
    window:perform_action(act.SwitchToWorkspace { name = value }, pane)
  end
end)

config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 3000 }

config.keys = {
  -- send a literal Ctrl+a (leader, Ctrl+a)
  { key = 'a', mods = 'LEADER|CTRL', action = act.SendKey { key = 'a', mods = 'CTRL' } },

  -- splits, vim semantics: h = :split (stacked), v = :vsplit (side by side)
  { key = 'h', mods = 'LEADER', action = act.SplitVertical { domain = 'CurrentPaneDomain' } },
  { key = 'v', mods = 'LEADER', action = act.SplitHorizontal { domain = 'CurrentPaneDomain' } },

  -- jump to a pane by its number (labels match the number shown in the bar)
  { key = 'p', mods = 'LEADER', action = act.PaneSelect { alphabet = '123456789' } },

  -- show/hide the bar
  {
    key = 'b',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, _)
      local overrides = window:get_config_overrides() or {}
      overrides.enable_tab_bar = overrides.enable_tab_bar == false
      window:set_config_overrides(overrides)
    end),
  },

  -- maximize/restore current pane
  { key = 'f', mods = 'LEADER', action = act.TogglePaneZoomState },

  -- close current pane (only asks if something other than the shell is running)
  { key = 'q', mods = 'LEADER', action = act.CloseCurrentPane { confirm = true } },

  -- pane navigation
  { key = 'h', mods = 'CTRL', action = act.ActivatePaneDirection 'Left' },
  { key = 'j', mods = 'CTRL', action = act.ActivatePaneDirection 'Down' },
  { key = 'k', mods = 'CTRL', action = act.ActivatePaneDirection 'Up' },
  { key = 'l', mods = 'CTRL', action = act.ActivatePaneDirection 'Right' },

  -- pane resizing
  { key = 'H', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Left', 3 } },
  { key = 'J', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Down', 3 } },
  { key = 'K', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Up', 3 } },
  { key = 'L', mods = 'CTRL|SHIFT', action = act.AdjustPaneSize { 'Right', 3 } },

  -- copy mode (vim keys, v to select, y to copy and exit) and quick select (labels copy matches)
  { key = '[', mods = 'LEADER', action = act.ActivateCopyMode },
  { key = 'Space', mods = 'LEADER', action = act.QuickSelect },

  -- sessions (workspaces)
  { key = 's', mods = 'LEADER', action = act.SpawnCommandInNewTab { args = { wezterm.config_dir .. '/sessions.sh' } } },
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
  {
    key = 'r',
    mods = 'LEADER',
    action = act.PromptInputLine {
      description = 'Rename session:',
      action = wezterm.action_callback(function(_, _, line)
        if line and line ~= '' then
          wezterm.mux.rename_workspace(wezterm.mux.get_active_workspace(), line)
        end
      end),
    },
  },

  -- open a project as a session named after its folder (switches to it if it already exists)
  {
    key = 'o',
    mods = 'LEADER',
    action = wezterm.action_callback(function(window, pane)
      window:perform_action(act.InputSelector {
        title = 'Projects',
        fuzzy = true,
        choices = project_choices(),
        action = wezterm.action_callback(function(win, p, id, _)
          if id then
            win:perform_action(act.SwitchToWorkspace {
              name = id:match '([^/]+)$',
              spawn = { cwd = id },
            }, p)
          end
        end),
      }, pane)
    end),
  },

  -- connect to a server from ssh_domains (fuzzy list)
  -- { key = 'c', mods = 'LEADER', action = act.ShowLauncherArgs { flags = 'FUZZY|DOMAINS' } },
}

-- save the current session to disk now / restore a saved one (e.g. after a reboot)
if resurrect then
  table.insert(config.keys, {
    key = 'S',
    mods = 'LEADER|SHIFT',
    action = wezterm.action_callback(function(_, _)
      resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
    end),
  })
  table.insert(config.keys, {
    key = 'R',
    mods = 'LEADER|SHIFT',
    action = wezterm.action_callback(function(window, pane)
      resurrect.fuzzy_loader.fuzzy_load(window, pane, function(id, _)
        local name = id:match '([^/]+)$':match '(.+)%..+$'
        local state = resurrect.state_manager.load_state(name, 'workspace')
        resurrect.workspace_state.restore_workspace(state, {
          spawn_in_workspace = true,
          relative = true,
          restore_text = true,
          on_pane_restore = resurrect.tab_state.default_on_pane_restore,
        })
        window:perform_action(act.SwitchToWorkspace { name = state.workspace }, pane)
      end, { ignore_windows = true, ignore_tabs = true, title = 'Restore session' })
    end),
  })
end

return config
