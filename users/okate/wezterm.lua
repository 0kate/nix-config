local wezterm = require 'wezterm'
local config = {}

-- Fix window title with "WezTerm"
wezterm.on('format-window-title', function(tab, pane, tabs, panes, config)
  return 'WezTerm'
end)

config.color_scheme = 'AtomOneLight'
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
  -- { family = 'Hack Nerd Font' },
  -- { family = 'Hack Nerd Font', assume_emoji_presentation = true },
  -- { family = 'Monaspace Neon Var', weight = 'Medium' },
  -- { family = 'Monaspace Neon Var', weight = 'Medium', assume_emoji_presentation = true, harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' }, },
  { family = 'JetBrains Mono', weight = 'Light', harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } },
  { family = 'JetBrains Mono', weight = 'Light', assume_emoji_presentation = true, harfbuzz_features = { 'calt=0', 'clig=0', 'liga=0' } },
})
config.harfbuzz_features = { 'zero' }
config.hide_tab_bar_if_only_one_tab = true
config.line_height = 1.2
config.use_ime = true
config.window_decorations = 'TITLE | RESIZE'
config.window_padding = {
  top = 0,
  right = 0,
  left = 0,
  bottom = 0,
}

return config
