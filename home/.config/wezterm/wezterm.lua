-- WezTerm configuration
-- Source of truth in ~/.dotfiles/home/.config/wezterm; home-manager symlinks
-- the whole dir to ~/.config/wezterm.
-- Colors are not configured here. The theme switcher decides them: `theme
-- <name>` rewrites the generated Lua this file reads, then touches this file so
-- a running WezTerm reloads it.

local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ── Font ───────────────────────────────────────────────────────────────
-- FiraCode Nerd Font Mono so Neovim/devicons render.
config.font = wezterm.font_with_fallback {
  'FiraCode Nerd Font Mono',
  'FiraCode Nerd Font',
}
config.font_size = 14.0

-- ── Colors ─────────────────────────────────────────────────────────────
-- No palette is authored here. The switcher names one of WezTerm's own built-in
-- schemes and everything below is derived from that scheme, so adding a Theme is
-- never a color edit in this file. See ADR-0002 in
-- bryceeppler/bryces-theme-switcher.
local SCHEMES = wezterm.color.get_builtin_schemes()

-- What this config shows before the switcher has ever run on the machine,
-- which is the state a freshly cloned dotfiles repo is in. It duplicates one
-- Theme's identity, which ADR-0001 accepts knowingly as the price of keeping
-- the Active Theme out of a version-controlled file.
local FALLBACK_SCHEME = 'GitHub Dark'

-- The generated Lua, in the machine-local state directory that is never
-- committed. It hands back a table naming the scheme to show, having resolved a
-- Pairing against the current appearance itself.
local GENERATED_LUA = wezterm.home_dir .. '/.local/state/theme-switcher/wezterm.lua'

-- The scheme the switcher says to show, or the fallback when it has nothing to
-- say. Missing, unreadable, and malformed all land on the fallback rather than
-- raising: a config that fails to load leaves no working terminal to fix it
-- from.
local function active_scheme()
  local ok, active = pcall(dofile, GENERATED_LUA)
  if not ok or type(active) ~= 'table' or type(active.scheme) ~= 'string' then
    return FALLBACK_SCHEME
  end
  return active.scheme
end

-- WCAG relative luminance. `linear_rgba` has already undone the sRGB transfer
-- curve, so this is the weighted sum and nothing else.
local function luminance(color)
  local r, g, b = color:linear_rgba()
  return 0.2126 * r + 0.7152 * g + 0.0722 * b
end

-- The WCAG contrast ratio between two colors: 1 when they are the same color,
-- 21 for black against white.
--
-- WezTerm's own `Color:contrast_ratio()` is not this and cannot be substituted
-- for it. The two agree on black against white and nowhere useful: a mid grey
-- sits near 4.5 against both white and black, where that method answers 2.05
-- and 10.25. It reads low over a light background and high over a dark one, so
-- a floor calibrated against it would stop dimming entirely on the light half
-- of a Pairing.
local function contrast(a, b)
  local lighter, darker = luminance(a), luminance(b)
  if lighter < darker then
    lighter, darker = darker, lighter
  end
  return (lighter + 0.05) / (darker + 0.05)
end

-- How far the tab bar's raised surface sits from the terminal background, in
-- lightness: enough to lift the active tab off the background, not enough to
-- read as a second color.
local SURFACE_LIFT = 0.06

-- An inactive tab's label is the foreground dimmed toward the background, one
-- step at a time, for as long as it stays this readable against it.
local DIM_STEP = 0.02
local DIM_STEPS = 12
local DIM_FLOOR = 4.5

-- Tab bar chrome computed from the scheme's own palette, because a built-in
-- scheme defines the terminal's colors and says nothing about the tab bar.
--
-- Only the background and the foreground are read, and deliberately not the
-- ANSI colors. Those are a scheme's accents, chosen to stand out against its
-- background rather than to sit quietly beside it, so chrome built from them
-- would take on a different character in every scheme and compete with the
-- terminal's own output. The background and the foreground are the one pair
-- every scheme guarantees a working relationship between, which is what makes
-- one rule safe across all of them.
local function tab_bar(background, foreground)
  local bg = wezterm.color.parse(background)
  local fg = wezterm.color.parse(foreground)

  -- Moving toward and away from the foreground, rather than up and down, is
  -- what lets one rule serve a dark scheme and a light one.
  local light_on_dark = luminance(fg) >= luminance(bg)
  local function lift(color, amount)
    return light_on_dark and color:lighten_fixed(amount) or color:darken_fixed(amount)
  end
  local function dim(color, amount)
    return light_on_dark and color:darken_fixed(amount) or color:lighten_fixed(amount)
  end

  local surface = lift(bg, SURFACE_LIFT)

  -- The dimmest an inactive label can be and still be read at a glance. A
  -- scheme whose own foreground is already below the floor keeps that
  -- foreground: nothing here can be more legible than the text the scheme
  -- itself writes in.
  local muted = fg
  for _ = 1, DIM_STEPS do
    local dimmer = dim(muted, DIM_STEP)
    if contrast(dimmer, bg) < DIM_FLOOR then
      break
    end
    muted = dimmer
  end

  return {
    background = tostring(bg),
    active_tab = { bg_color = tostring(surface), fg_color = tostring(fg), intensity = 'Bold' },
    inactive_tab = { bg_color = tostring(bg), fg_color = tostring(muted) },
    inactive_tab_hover = { bg_color = tostring(surface), fg_color = tostring(fg) },
    new_tab = { bg_color = tostring(bg), fg_color = tostring(muted) },
    new_tab_hover = { bg_color = tostring(surface), fg_color = tostring(fg) },
  }
end

-- Whether a scheme can be shown at all, which is a stronger question than
-- whether WezTerm has one by that name. A scheme is not obliged to say what its
-- background and foreground are, and `alacritty`, alone among the 1079, says
-- nothing but its indexed colors and leaves WezTerm's own defaults to stand;
-- there is nothing there to derive a tab bar from.
local function usable(scheme)
  return scheme ~= nil and scheme.background ~= nil and scheme.foreground ~= nil
end

-- The scheme that will actually be shown for `name`, and the tab bar that
-- belongs with it. The name comes back because it is not always the one that
-- went in: a scheme this config cannot show would leave the window on its
-- previous colors and the tab bar on some other scheme's, so it falls back
-- exactly as a missing file does, and says so by handing back a different name.
local function as_shown(name)
  if not usable(SCHEMES[name]) then
    name = FALLBACK_SCHEME
  end
  local scheme = SCHEMES[name]
  return name, { tab_bar = tab_bar(scheme.background, scheme.foreground) }
end

local scheme_name, scheme_colors = as_shown(active_scheme())
config.color_scheme = scheme_name
config.colors = scheme_colors

-- ── Preview ────────────────────────────────────────────────────────────
-- The picker shows a Theme without committing it by setting a WezTerm user var
-- over the terminal it is running in. That arrives here, and becomes an
-- override on that one window; an empty value means the Preview is over and
-- takes the override off. See ADR-0005 in bryceeppler/bryces-theme-switcher,
-- and `src/nudge.rs` there for the end that sends it: this name is spelled out
-- on both sides of that seam and nothing checks that the two still agree.
local PREVIEW_VAR = 'theme_preview'

wezterm.on('user-var-changed', function(window, _pane, name, value)
  if name ~= PREVIEW_VAR then
    return
  end

  local overrides = window:get_config_overrides() or {}
  if value == '' then
    overrides.color_scheme = nil
    overrides.colors = nil
  else
    local previewed, previewed_colors = as_shown(value)
    -- A Preview naming a scheme this config cannot show is a Preview that did
    -- not arrive, which is what a name coming back changed means here. It must
    -- not knock the window off the Active Theme, and must not fall back either:
    -- the fallback is what to show when nothing has been chosen, not what to
    -- show instead of what was.
    if previewed ~= value then
      return
    end
    overrides.color_scheme = previewed
    overrides.colors = previewed_colors
  end
  window:set_config_overrides(overrides)
end)

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
