-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This table will hold the configuration.
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- <<< Configuration choices >>>

-- Set colour scheme according to OS dark / light mode
local function scheme_for_appearance(appearance)
  if appearance:find "Dark" then
    return 'Catppuccin Mocha' -- or Macchiato, Frappe, Latte
  else
    return 'Catppuccin Latte'
  end
end
config.color_scheme = scheme_for_appearance(wezterm.gui.get_appearance())

-- Font
config.font = wezterm.font_with_fallback {
    { family = 'Comic Code Ligatures', weight = 'Medium' },
    { family = 'ComicCodeLigatures Nerd Font Propo', weight = 'Medium' },
    -- { family = 'Symbols Nerd Font Mono', scale = 0.90 }
}
config.use_cap_height_to_scale_fallback_fonts = true -- do we even need this?
config.font_size = 15.0
config.line_height = 1.2
config.cell_width = 0.9

-- Window 
config.native_macos_fullscreen_mode = false
config.window_decorations = 'RESIZE'
config.window_close_confirmation = 'NeverPrompt'
config.enable_tab_bar = false
config.default_gui_startup_args = {'start', '--position', '0,0'}
config.initial_rows = 28
config.initial_cols = 151
config.window_padding = {
    left = 0,
    right = 0
}

-- Cursor
config.default_cursor_style = 'BlinkingBlock'
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'

-- Keybinds
config.key_map_preference = "Mapped"

local mappings = require 'mappings'
mappings.apply_to_config(config)

-- return the configuration to wezterm
return config

