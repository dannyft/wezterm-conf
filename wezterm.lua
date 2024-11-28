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
    { mods = key.ledr, key = "r",          action = act.PromptInputLine({
        description = "Enter new name for tab",
        action = wezterm.action_callback(function (window, _, line)
          if line then
            window:active_tab():set_title(line)
          end
        end),
      }),
    },
}

local bar = wezterm.plugin.require("https://github.com/adriankarlen/bar.wezterm")
bar.apply_to_config(config, {
  modules = {
    username = { enabled = false },
    hostname = { enabled = false },
    cws      = { enabled = false },
  }
})

return config
