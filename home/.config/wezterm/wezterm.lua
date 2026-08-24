-- WezTerm configuration
-- Source of truth in ~/.dotfiles/home/.config/wezterm; home-manager symlinks
-- the whole dir to ~/.config/wezterm.
-- Theme: Ayu Dark

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ── Font ───────────────────────────────────────────────────────────────
-- FiraCode Nerd Font Mono so Neovim/devicons render.
config.font = wezterm.font_with_fallback {
  'FiraCode Nerd Font Mono',
  'FiraCode Nerd Font',
}
config.font_size = 14.0

-- ── Colors: Ayu Dark ──────────────────────────────────────────────────
-- WezTerm provides the terminal palette. These matching Ayu UI colors keep
-- the tab bar visually consistent with it.
local p = {
  bg = '#0a0e14',
  surface = '#14191f',
  fg = '#b3b1ad',
  muted = '#7a838c',
}

config.color_scheme = 'Ayu Dark (Gogh)'

-- Tab-bar chrome is not part of a color scheme, so style it separately.
config.colors = {
  tab_bar = {
    background = p.bg,
    active_tab = { bg_color = p.surface, fg_color = p.fg, intensity = 'Bold' },
    inactive_tab = { bg_color = p.bg, fg_color = p.muted },
    inactive_tab_hover = { bg_color = p.surface, fg_color = p.fg },
    new_tab = { bg_color = p.bg, fg_color = p.muted },
    new_tab_hover = { bg_color = p.surface, fg_color = p.fg },
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
