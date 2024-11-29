local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'powershell.exe' }
end

--config.font = wezterm.font 'Fira Code'
config.font_size = 16.0
--config.color_scheme = 'Catppuccin Mocha'
config.colors = {
  background = "11111b",
  tab_bar = {
    background = "11111b",
    new_tab = {
      fg_color = "#ffffff",
      bg_color = '#11111b',
    },
  },
}

config.enable_scroll_bar = false
config.enable_tab_bar = true
config.hide_tab_bar_if_only_one_tab = false
config.use_fancy_tab_bar = false
config.tab_max_width = 25
config.show_tab_index_in_tab_bar = false
config.tab_bar_at_bottom = true
config.switch_to_last_active_tab_when_closing_tab = true
config.window_close_confirmation = 'NeverPrompt'

config.window_padding = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0,
}

local key = {}
if wezterm.target_triple == "aarch64-apple-darwin" then
  key.ctrl = "CMD"
  key.ctrs = "CMD|SHIFT"
  key.alt  = "ALT"
  key.ledr = "LEADER"
else
  key.ctrl = "CTRL"
  key.ctrs = "CTRL|SHIFT"
  key.alt  = "ALT"
  key.ledr = "LEADER"
end

if wezterm.target_triple == "aarch64-apple-darwin" then
  config.leader = { key = "p", mods = "SUPER", timeout_milliseconds = 2000 }
else
  config.leader = { key = "p", mods = "CTRL", timeout_milliseconds = 2000 }
end

config.keys = {
  { mods = key.ctrl, key = "t",          action = act.SpawnTab "CurrentPaneDomain" },
  { mods = key.ledr, key = "n",          action = act.SpawnTab "CurrentPaneDomain" },
  { mods = key.ledr, key = "x",          action = act.CloseCurrentPane { confirm = true } },
  { mods = key.alt,  key = "LeftArrow",  action = act.ActivateTabRelative(-1) },
  { mods = key.alt,  key = "RightArrow", action = act.ActivateTabRelative(1) },
  { mods = key.ledr, key = "`",          action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { mods = key.ledr, key = "-",          action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { mods = key.ctrl, key = "LeftArrow",  action = act.ActivatePaneDirection "Left" },
  { mods = key.ctrl, key = "DownArrow",  action = act.ActivatePaneDirection "Down" },
  { mods = key.ctrl, key = "UpArrow",    action = act.ActivatePaneDirection "Up" },
  { mods = key.ctrl, key = "RightArrow", action = act.ActivatePaneDirection "Right" },
  { mods = key.ledr, key = "LeftArrow",  action = act.AdjustPaneSize { "Left", 5 } },
  { mods = key.ledr, key = "RightArrow", action = act.AdjustPaneSize { "Right", 5 } },
  { mods = key.ledr, key = "DownArrow",  action = act.AdjustPaneSize { "Down", 5 } },
  { mods = key.ledr, key = "UpArrow",    action = act.AdjustPaneSize { "Up", 5 } },
  { mods = key.ctrs, key = "c",          action = act.CopyTo "Clipboard" },
  { mods = key.ctrl, key = "v",          action = act.PasteFrom "Clipboard" },
  { mods = key.ledr, key = "f",          action = act.Search "CurrentSelectionOrEmptyString" },
  { mods = key.ledr, key = "c",          action = act.ClearScrollback "ScrollbackOnly" },
  { mods = key.ledr, key = " ",          action = act.ActivateCommandPalette },
  { mods = key.ledr, key = "?",          action = act.ActivateKeyTable { name = "help_mode", one_shot = true } },
  { mods = key.ledr, key = "Enter",      action = act.ActivateCopyMode },
  { mods = key.ledr, key = "t",          action = act.ShowTabNavigator },
  {
    mods = key.ledr,
    key = "r",
    action = act.PromptInputLine({
      description = "Enter new name for tab",
      action = wezterm.action_callback(function(window, _, line)
        if line then
          window:active_tab():set_title(line)
        end
      end),
    }),
  },
}

local SOLID_LEFT_ARROW = wezterm.nerdfonts.ple_left_half_circle_thick
local SOLID_RIGHT_ARROW = wezterm.nerdfonts.ple_right_half_circle_thick

function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on('format-tab-title', function(tab, tabs, panes, cfg, hover, max_width)
  local edge_background = '#0b0022'
  local background = '#24273a'
  local foreground = '#cad3f5'

  if tab.is_active then
    background = '#f5a97f'
    foreground = '#1e2030'
    index_fg = "#1e2030"
    index_bg = "#f5a97f"
  elseif hover then
    background = '#24273a'
    foreground = '#cad3f5'
    index_fg = "#1e2030"
    index_bg = "#ffffff"
  end

  local edge_foreground = index_bg
  local index = tab.tab_index + 1
  local title = tab_title(tab)

  -- ensure that the titles fit in the available space,
  -- and that we have room for the edges.
  title = wezterm.truncate_right(title, max_width - 2)

  return {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = index_bg } },
    { Foreground = { Color = index_fg } },
    { Text = tostring(index) .. " " },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. title .. " " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = background } },
    { Text = SOLID_RIGHT_ARROW },
    { Text = " " },
  }
end
)

wezterm.on("update-status", function(window, pane)
  local edge_background = '#0b0022'
  local edge_foreground = '#a6da95'
  local background = '#a6da95'
  local foreground = '#1e2030'

  local left_cells = {
    -- { Text = " " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = wezterm.nerdfonts.cod_window .. " " },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. window:active_workspace() .. " " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = background } },
    { Text = SOLID_RIGHT_ARROW },
    { Text = " " },
  }

  window:set_left_status(wezterm.format(left_cells))

  edge_background = '#0b0022'
  edge_foreground = '#8aadf4'
  background = '#8aadf4'
  foreground = '#1e2030'


  local right_cells = {
    { Background = { Color = edge_background } },
    { Foreground = { Color = edge_foreground } },
    { Text = SOLID_LEFT_ARROW },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = wezterm.nerdfonts.md_calendar_clock_outline .. " " },
    { Background = { Color = background } },
    { Foreground = { Color = foreground } },
    { Text = " " .. wezterm.time.now():format "%H:%M" .. " " },
    { Background = { Color = edge_background } },
    { Foreground = { Color = background } },
    { Text = SOLID_RIGHT_ARROW },
    -- { Text = " " },
  }

  window:set_right_status(wezterm.format(right_cells))
end)

--[[local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
  modules = {
    username = { enabled = false },
    hostname = { enabled = false },
    cws      = { enabled = false },
  }
})]]

return config
