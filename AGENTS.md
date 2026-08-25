# Project agent memory

This file is the project's committed home for project-intrinsic agent knowledge: build, test, release, architecture, and sharp-edge notes that should travel with the code.

- Add durable project-specific notes here as they are discovered through real work.

## Shell PATH: interactive vs non-interactive

`~/.zshenv` is home-manager-managed and sourced by *every* zsh (including non-interactive `zsh -c ...`).
It sources `hm-session-vars.sh`, which is where `home.sessionVariables` and `home.sessionPath` land.
The nix profile bin dirs (`/etc/profiles/per-user/<user>/bin`, `/run/current-system/sw/bin`) are only added by the login/interactive init (`/etc/zprofile`, `/etc/zshrc`), which non-interactive non-login shells never read.
So any CLI those shells need from profile-specific paths must go through `home.sessionPath` in `home.nix`, not `programs.zsh.initContent` (interactive-only) - the directly installed Herdr binary in `~/.local/bin` is one example.
`path` is `typeset -U`, so duplicate dirs are de-duplicated automatically.

## Follower configs: never dim with bright black

Configs that follow the terminal palette (tmux today; anything else that stops carrying its own theme) reach for `colour8`/bright black as the "muted" colour.
It is the wrong slot.
Bright black is under 3:1 contrast against its own scheme's background in 687 of WezTerm's 1078 built-in schemes, and Solarized Dark sets it to *exactly* the background, which erases the text outright rather than merely dimming it.
Measured by walking `wezterm.color.get_builtin_schemes()` from a throwaway `--config-file` and computing WCAG contrast per scheme.

Use `default` plus the `dim` attribute instead.
That dims the terminal's own foreground, so it tracks the palette, and a terminal that ignores `dim` degrades to plain readable text rather than to invisible text.
The same argument makes `reverse` the right way to draw a coloured pill: it paints the label in the terminal's background colour, which is the one colour guaranteed to contrast with the pill under both light and dark schemes.
`fg=colour0` or `fg=colour15` each work under only one of the two.

## Agent CLI themes: leave them following the terminal

Claude Code and Codex are Followers of the theme switcher, so neither carries a theme of its own.
Claude Code gets there with `"theme": "auto"` in `home/.claude/settings.json`.
Codex gets there by having **no** `tui.theme` in `~/.codex/config.toml`, because setting that key at all disables its adaptive default.
Don't add one to either, and don't chase the lag after a theme switch: the switcher's own README explains why they only pick their theme up at the next session.

`home/.claude/settings.json` is linked as a single file rather than by linking `~/.claude`, because everything else in that directory is runtime state (history, projects, credentials).
Claude Code rewrites the file in place through the symlink instead of replacing it, which is what makes the link survive its own writes - verified against `claude plugin marketplace add` with a symlinked `settings.json`.
Incidental writes from inside a session (survey timestamps, plugin state) therefore land in the repo as a diff; that is the cost of tracking the file at all, not a sign anything is wrong.
