# Terminal cheat sheet — WezTerm + tmux + Neovim

WezTerm and Neovim both use **GitHub Dark Default**.
tmux has no theme of its own: it follows the terminal's ANSI palette, so it re-themes itself whenever WezTerm does.
Neovim's own keymap sheet lives at `~/.config/nvim/CHEATSHEET.md`.

---

## Mental model: who does what?

You have three layers. They overlap on purpose — here's the sane division:

| Layer | Job | Use it for |
|---|---|---|
| **WezTerm** | The terminal window (GPU-drawn, fonts, colors) | Launching, one or two tabs, zoom |
| **tmux** | Session/pane manager *inside* the terminal | Splits, persistent sessions, remote work |
| **Neovim** | The editor | Editing code |

**Rule of thumb:** let **tmux** own your splits and sessions (they survive closing
the window / SSH drops). Keep WezTerm tabs minimal. Neovim handles editing.

---

## WezTerm (the terminal)

Uses native macOS shortcuts. Prefix is `Cmd`.

| Keys | Action |
|---|---|
| `Cmd + T` | New tab |
| `Cmd + W` | Close tab/pane |
| `Cmd + 1..9` | Jump to tab N |
| `Cmd + Shift + [` / `]` | Prev / next tab |
| `Cmd + D` | Split pane **right** |
| `Cmd + Shift + D` | Split pane **down** |
| `Cmd + [` / `]` | Move between panes |
| `Cmd + +` / `-` / `0` | Font size up / down / reset |
| `Cmd + K` | Clear scrollback |
| `Cmd + F` | Search scrollback |
| `Cmd + Shift + P` | Command palette (discover everything) |

> Since tmux also does splits, you'll mostly use WezTerm just for tabs + zoom and
> let tmux handle panes. That's fine — pick whichever feels natural per task.

Config: `~/.config/wezterm/wezterm.lua` → edits apply **instantly** on save (no restart).

---

## tmux (the multiplexer)

**Prefix = `Ctrl + b`.** You press the prefix, let go, then press the command key.
Written below as `<prefix>`. (To switch the prefix to `Ctrl + a`, uncomment the
block in `tmux.conf`.)

### Sessions (the big win — these persist)
| Command | Action |
|---|---|
| `tmux` | Start a new session |
| `tmux new -s work` | New **named** session "work" |
| `tmux ls` | List sessions |
| `tmux attach -t work` | Re-attach to "work" |
| `<prefix> d` | **Detach** (session keeps running in background) |
| `<prefix> s` | Visual session switcher |
| `<prefix> $` | Rename current session |

*Detach + re-attach is the killer feature: close the terminal, your work is still
running. Reattach later exactly where you left off.*

### Windows (like tabs)
| Keys | Action |
|---|---|
| `<prefix> c` | New window |
| `<prefix> 1..9` | Jump to window N |
| `<prefix> n` / `p` | Next / previous window |
| `<prefix> ,` | Rename window |
| `<prefix> w` | Visual window list |
| `<prefix> &` | Kill window |

### Panes (splits)
| Keys | Action |
|---|---|
| `<prefix> \|` | Split **vertically** (side by side) |
| `<prefix> -` | Split **horizontally** (stacked) |
| `<prefix> h/j/k/l` | Move to pane left/down/up/right |
| `<prefix> z` | **Zoom** pane to fullscreen (toggle) |
| `<prefix> x` | Kill pane |
| `<prefix> {` / `}` | Swap pane position |
| `<prefix> Space` | Cycle through layouts |
| *drag borders / click* | Mouse is on — resize & select by mouse |

### Copy mode (scroll & select text)
| Keys | Action |
|---|---|
| `<prefix> [` | Enter copy mode (then scroll with arrows / `Ctrl+u`/`Ctrl+d`) |
| `v` | Start selection (vi-style) |
| `y` | Copy selection to system clipboard |
| `/` then text | Search backward in scrollback |
| `q` or `Esc` | Quit copy mode |

### Housekeeping
| Keys | Action |
|---|---|
| `<prefix> r` | Reload config (after editing `tmux.conf`) |
| `<prefix> ?` | List **all** key bindings |
| `<prefix> t` | Show a big clock (fun) |

Config: `~/.config/tmux/tmux.conf` → reload with `<prefix> r`.

---

## A typical workflow

```sh
tmux new -s snapcaster     # start a named session for a project
<prefix> |                 # split: editor left, terminal right
nvim .                     # (in the left pane) edit code
<prefix> l                 # hop to the right pane to run commands
<prefix> z                 # zoom a pane fullscreen when you need focus
<prefix> d                 # detach and go to lunch — it keeps running
# ...later...
tmux attach -t snapcaster  # right back where you were
```

---

## First-time setup checklist

1. **Open WezTerm** (Spotlight → "WezTerm"). It's already themed.
2. In WezTerm, run `tmux` - you should see the status bar at the bottom, tinted from WezTerm's own palette.
3. Open Neovim (`nvim`) inside tmux and confirm colors look right (truecolor is
   wired through tmux, so `github_dark_default` renders correctly).
4. Optional: set WezTerm as your default terminal and retire iTerm2 once happy.

## Where things live
- WezTerm: `~/.dotfiles/home/.config/wezterm/` → `~/.config/wezterm/` (home-manager)
- tmux:    `~/.dotfiles/home/.config/tmux/`   → `~/.config/tmux/` (home-manager)
- Neovim:  `~/.config/nvim/` (+ its own `CHEATSHEET.md`)
- Themes:  `~/.dotfiles/home/.config/theme-switcher/` → `~/.config/theme-switcher/` (home-manager)
- WezTerm and Neovim use `~/.dotfiles/iterm2/GitHub Dark Default.itermcolors` as their palette source.
  WezTerm spells the palette out in `wezterm.lua` rather than using a bundled scheme, so it matches exactly.
  tmux is not in that list on purpose: it reads no palette, and takes its colors from whatever ANSI colors the terminal defines.
