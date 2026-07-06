-- WezTerm configuration
-- Source of truth in ~/.dotfiles/home/.config/wezterm; home-manager symlinks
-- the whole dir to ~/.config/wezterm.
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
-- One palette table is the single source of truth: it defines the color
-- scheme AND the tab-bar chrome, so the two can never drift apart.
-- Canonical origin of these values: ~/.dotfiles/iterm2/GitHub Dark Default.itermcolors
-- (also mirrored by Neovim's github_dark_default).
local p = {
  bg        = '#0d1117',
  surface   = '#161b22',
  fg        = '#e6edf3',
  muted     = '#8b949e',
  selection = '#264f78',
  ansi    = { '#484f58', '#ff7b72', '#3fb950', '#d29922', '#58a6ff', '#bc8cff', '#39c5cf', '#b1bac4' },
  brights = { '#6e7681', '#ffa198', '#56d364', '#e3b341', '#79c0ff', '#d2a8ff', '#56d4dd', '#ffffff' },
}

-- Define the scheme inline from the palette, then select it by name.
config.color_schemes = {
  ['GitHub Dark Default'] = {
    background = p.bg,
    foreground = p.fg,
    cursor_bg = p.fg,
    cursor_fg = p.bg,
    cursor_border = p.fg,
    selection_bg = p.selection,
    selection_fg = p.fg,
    ansi = p.ansi,
    brights = p.brights,
  },
}
-- config.color_scheme = 'GitHub Dark Default'
config.color_scheme = 'rose-pine-moon'

-- Tab-bar chrome isn't part of a color_scheme, so it's styled here - but from
-- the same palette so it stays in sync with the scheme.
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
