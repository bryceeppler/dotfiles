# dotfiles

Standardized terminal setup for macOS. Source of truth for shell, prompt, and
iTerm2 configuration. Files in `$HOME` are **symlinks** back into this repo, so
editing here = editing your live config.

## Layout

| Repo file | Symlinked to | Purpose |
|---|---|---|
| `zshenv`  | `~/.zshenv`  | Runs for every zsh. Kept minimal. |
| `zprofile`| `~/.zprofile`| Login shells: PATH (brew, ebcli, orbstack, ~/.local/bin). |
| `zshrc`   | `~/.zshrc`   | Interactive: history, completion, aliases, nvm, plugins, starship. |
| `starship.toml` | `~/.config/starship.toml` | Prompt config. |
| `iterm2/com.googlecode.iterm2.plist` | (iTerm custom prefs folder) | iTerm2 settings. |

Neovim lives at `~/.config/nvim` (NvChad — its own git repo) and is intentionally
**not** vendored here.

## Bootstrap on a new machine

```sh
git clone <this-repo> ~/dotfiles
ln -sf ~/dotfiles/zshenv   ~/.zshenv
ln -sf ~/dotfiles/zprofile ~/.zprofile
ln -sf ~/dotfiles/zshrc    ~/.zshrc
mkdir -p ~/.config && ln -sf ~/dotfiles/starship.toml ~/.config/starship.toml
```

## iTerm2 (themes the best-practice way)

iTerm2 stores its whole config in `iterm2/com.googlecode.iterm2.plist`, loaded via
its **custom preferences folder** feature so it's version-controlled.

**Activate it (one time):**
1. iTerm2 → Settings → General → Settings.
2. Check **"Load settings from a custom folder or URL"** and pick `~/dotfiles/iterm2`.
3. When prompted, choose **Load** (loads the committed plist).
4. Set the save dropdown to **Automatically** so changes flow back to the repo on quit.

**Theme:** **GitHub Dark Default**, matching the Cursor/VS Code editor theme. Colors were
pulled directly from the installed `github-vscode-theme` and installed as a reusable
**Color Preset** named "GitHub Dark Default" (Settings → Profiles → Colors → Color Presets).
To switch themes, import a `.itermcolors` file as a preset and apply it — don't hand-edit
individual colors. Browse presets at https://github.com/mbadolato/iTerm2-Color-Schemes.

**Font:** FiraCode Nerd Font Mono (size 14) so Neovim/NvChad icons render.

## Matching themes everywhere

Everything is on **GitHub Dark**:
- iTerm2 → "GitHub Dark Default" color preset (above).
- Neovim → NvChad base46 theme `github_dark` (set in `~/.config/nvim/lua/custom/chadrc.lua`).
- starship prompt → recolored with the GitHub Dark palette (blue dir, purple branch,
  yellow git status, green/red prompt character).

## Backups

Pre-standardization copies of every file are in `~/dotfiles-backup-<timestamp>/`.
