local wezterm = require 'wezterm'
local config = {}

config.color_scheme = 'Ayu Mirage (Gogh)'
config.colors = {
  cursor_bg = '#666666',
}
config.cursor_blink_ease_in = 'Constant'
config.cursor_blink_ease_out = 'Constant'
config.cursor_blink_rate = 500
config.debug_key_events = true
config.default_cursor_style = 'BlinkingBlock'
config.enable_scroll_bar = false
config.font = wezterm.font_with_fallback({
  { family = 'Hack Nerd Font' },
  { family = 'Hack Nerd Font', assume_emoji_presentation = true },
})
config.line_height = 1.2
config.use_ime = true
config.window_decorations = 'RESIZE'
config.window_padding = {
  top = 0,
  right = 0,
  left = 0,
  bottom = 0,
}

return config
