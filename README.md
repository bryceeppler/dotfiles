# dotfiles

Standardized terminal setup for macOS. Source of truth for shell, prompt,
terminal, and multiplexer configuration. Files in `$HOME` are **symlinks** back
into this repo, so editing here = editing your live config.

## Layout

| Repo file | Symlinked to | Purpose |
|---|---|---|
| `zshenv`  | `~/.zshenv`  | Runs for every zsh. Kept minimal. |
| `zprofile`| `~/.zprofile`| Login shells: PATH (brew, ebcli, orbstack, ~/.local/bin). |
| `zshrc`   | `~/.zshrc`   | Interactive: history, completion, aliases, nvm, plugins, starship. |
| `starship.toml` | `~/.config/starship.toml` | Prompt config. |
| `wezterm/wezterm.lua` | `~/.config/wezterm/wezterm.lua` | WezTerm terminal (primary). |
| `tmux/tmux.conf` | `~/.config/tmux/tmux.conf` | tmux multiplexer. |
| `iterm2/com.googlecode.iterm2.plist` | (iTerm custom prefs folder) | iTerm2 settings (legacy/backup). |

Neovim lives at `~/.config/nvim` (**kickstart.nvim** — its own git repo) and is
intentionally **not** vendored here.

## Bootstrap on a new machine

```sh
git clone <this-repo> ~/dotfiles
ln -sf ~/dotfiles/zshenv   ~/.zshenv
ln -sf ~/dotfiles/zprofile ~/.zprofile
ln -sf ~/dotfiles/zshrc    ~/.zshrc
mkdir -p ~/.config && ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
mkdir -p ~/.config/wezterm && ln -sf ~/dotfiles/wezterm/wezterm.lua ~/.config/wezterm/wezterm.lua
mkdir -p ~/.config/tmux && ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
```

Install the apps: `brew install --cask wezterm` and `brew install tmux`.

## Terminal: WezTerm (primary)

`wezterm/wezterm.lua` is the live config. Uses **FiraCode Nerd Font Mono** (size
14) and the **GitHub Dark Default** palette. The exact colours were pulled from
`iterm2/GitHub Dark Default.itermcolors` so the terminal palette is identical
across WezTerm, iTerm2, and Neovim.

## Multiplexer: tmux

`tmux/tmux.conf` — sensible defaults (mouse, big scrollback, 1-indexed windows,
vi copy mode, `|`/`-` splits) and a GitHub Dark status bar. Prefix is the default
`Ctrl-b` (there's a commented block to switch to `Ctrl-a`). No plugin manager —
plain single-file config. Reload in a running session with `prefix + r`.

## iTerm2 (legacy / backup)

iTerm2 stores its whole config in `iterm2/com.googlecode.iterm2.plist`, loaded via
its **custom preferences folder** feature so it's version-controlled. Kept as a
fallback; WezTerm is the daily driver now.

**Theme:** **GitHub Dark Default**, installed as a reusable Color Preset. To switch
themes, import a `.itermcolors` file as a preset and apply it — don't hand-edit
individual colors. Browse presets at https://github.com/mbadolato/iTerm2-Color-Schemes.

## Matching themes everywhere

Everything is on **GitHub Dark Default**:
- WezTerm → named scheme `GitHub Dark Default` in `wezterm/colors/GitHub Dark Default.toml`
  (auto-loaded from `~/.config/wezterm/colors/`, selected via `color_scheme` in wezterm.lua).
- tmux → GitHub Dark status bar + RGB passthrough in `tmux/tmux.conf`.
- iTerm2 → "GitHub Dark Default" color preset.
- Neovim → `projekt0n/github-nvim-theme`, colorscheme `github_dark_default`
  (set in `~/.config/nvim/init.lua`).
- starship prompt → recolored with the GitHub Dark palette.

## Backups

Pre-standardization copies of every file are in `~/dotfiles-backup-<timestamp>/`.
