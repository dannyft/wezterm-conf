local wezterm = require "wezterm"
local config = wezterm.config_builder()
local act = wezterm.action

if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
  config.default_prog = { 'powershell.exe' }
end

--config.font = wezterm.font 'Fira Code'
config.font_size = 16.0
config.color_scheme = 'Catppuccin Mocha'
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
}

local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup({ 
  options = {
    icons_enabled = true,
    theme = 'Catppuccin Mocha',
    color_overrides = {
      tab = {
        new_tab = { bg = "#11111b" },
      }
    },
    section_separators = {
      left = wezterm.nerdfonts.ple_upper_left_triangle, --pl_left_hard_divider,
      right = wezterm.nerdfonts.ple_upper_right_triangle, --pl_right_hard_divider,
    },
    component_separators = {
      left = wezterm.nerdfonts.ple_forwardslash_separator_redundant, --pl_left_soft,
      right = wezterm.nerdfonts.ple_backslash_separator_redundant, --pl_right_soft_divider,
    },
    tab_separators = {
      left = wezterm.nerdfonts.ple_lower_left_triangle,
      right = wezterm.nerdfonts.ple_lower_right_triangle,
    },
  },
  sections = {
    tabline_a = { 'mode' },
    tabline_b = { 'workspace' },
    tabline_c = { ' ' },
    tab_active = {
      'index',
      { 'parent', padding = 0 },
      '/',
      { 'cwd', padding = { left = 0, right = 1 } },
      { 'zoomed', padding = 0 },
    },
    tab_inactive = { 'index', { 'process', padding = { left = 0, right = 1 } } },
    tabline_x = { },
    tabline_y = { 'datetime', 'battery' },
    tabline_z = { 'hostname' },
  },
  extensions = {},
})

return config
