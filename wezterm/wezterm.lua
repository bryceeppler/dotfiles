-- WezTerm configuration
-- Source of truth in ~/dotfiles, symlinked to ~/.config/wezterm/wezterm.lua
-- Theme: GitHub Dark Default (matches Neovim + the iTerm2 preset)

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ── Font ───────────────────────────────────────────────────────────────
-- FiraCode Nerd Font Mono so Neovim/devicons render.
config.font = wezterm.font_with_fallback {
  'FiraCode Nerd Font Mono',
  'FiraCode Nerd Font',
}
config.font_size = 14.0

-- ── Colors: GitHub Dark Default ────────────────────────────────────────
-- Pulled from ~/dotfiles/iterm2/GitHub Dark Default.itermcolors so the
-- terminal palette is identical across iTerm2, WezTerm, and Neovim.
config.colors = {
  foreground = '#e6edf3',
  background = '#0d1117',
  cursor_bg = '#e6edf3',
  cursor_fg = '#0d1117',
  cursor_border = '#e6edf3',
  selection_bg = '#264f78',
  selection_fg = '#e6edf3',

  ansi = {
    '#484f58', -- black
    '#ff7b72', -- red
    '#3fb950', -- green
    '#d29922', -- yellow
    '#58a6ff', -- blue
    '#bc8cff', -- magenta
    '#39c5cf', -- cyan
    '#b1bac4', -- white
  },
  brights = {
    '#6e7681', -- bright black
    '#ffa198', -- bright red
    '#56d364', -- bright green
    '#e3b341', -- bright yellow
    '#79c0ff', -- bright blue
    '#d2a8ff', -- bright magenta
    '#56d4dd', -- bright cyan
    '#ffffff', -- bright white
  },

  tab_bar = {
    background = '#0d1117',
    active_tab = { bg_color = '#161b22', fg_color = '#e6edf3', intensity = 'Bold' },
    inactive_tab = { bg_color = '#0d1117', fg_color = '#8b949e' },
    inactive_tab_hover = { bg_color = '#161b22', fg_color = '#e6edf3' },
    new_tab = { bg_color = '#0d1117', fg_color = '#8b949e' },
    new_tab_hover = { bg_color = '#161b22', fg_color = '#e6edf3' },
  },
}

-- ── Sensible defaults ──────────────────────────────────────────────────
config.use_fancy_tab_bar = false          -- simple, retro tab bar
config.hide_tab_bar_if_only_one_tab = true -- no tab bar clutter with one tab
config.tab_bar_at_bottom = false
-- Frameless window: no macOS title bar and no stoplight (traffic-light) buttons.
-- Close/quit with Cmd+W / Cmd+Q, minimize with Cmd+M (see note in the cheat sheet).
config.window_decorations = 'RESIZE'
-- Frosted-glass background. Lower opacity = more see-through; set to 1.0 to turn
-- transparency off. Blur only takes effect while opacity < 1.0.
config.window_background_opacity = 0.8
config.macos_window_background_blur = 50
config.window_padding = { left = 8, right = 8, top = 8, bottom = 8 }
config.scrollback_lines = 10000
config.audible_bell = 'Disabled'
config.default_cursor_style = 'SteadyBlock'
-- Make the block cursor invert whatever cell it's over (like iTerm's "smart
-- cursor color") instead of forcing cursor_fg/cursor_bg. Without this, the block
-- cursor blacks out the first character of dim text such as zsh autosuggestions.
config.force_reverse_video_cursor = true
config.adjust_window_size_when_changing_font_size = false
config.max_fps = 120

return config
