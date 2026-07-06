# Neovim cheat sheet (kickstart)

**Leader key = `Space`.** Press `Space` and wait — **which-key** pops up showing every option. This is your safety net; you don't need to memorize anything below.

## Coming from Cursor

| Cursor | Neovim |
|---|---|
| `Cmd+P` (find file) | `Space s f` |
| `Cmd+Shift+F` (search in project) | `Space s g` (grep) |
| File tree toggle | `\` (backslash) |
| `Cmd+click` / F12 (go to definition) | `grd` |
| Rename symbol (F2) | `grn` |
| Quick fix / code action | `gra` |
| Hover docs | `K` |
| Format file | `Space f` (also auto-formats on save) |
| Command palette | `:` (Vim command line) |
| Switch open files | `Space Space` (buffers) |

## Finding things (Telescope)
- `Space s f` — **search files** (fuzzy)
- `Space s g` — **grep** across project
- `Space s .` — recent files
- `Space Space` — open buffers
- `Space s h` — search help docs
- `Space s k` — search keymaps (great for discovery)
- `Space s r` — resume last search

## File tree (neo-tree)
- `\` — reveal/toggle tree
- Inside tree: `a` add, `d` delete, `r` rename, `Enter` open, `?` help

## Code intelligence (LSP) — works in TS/JS, Python, Lua
- `grd` — go to definition
- `grr` — references
- `gri` — implementation
- `grn` — rename symbol
- `gra` — code action
- `K` — hover documentation
- `]d` / `[d` — next / previous diagnostic
- `Space q` — all diagnostics in a list
- `Space f` — format buffer (also runs automatically on save)

## Editing essentials (Vim basics)
- `i` insert · `Esc` back to normal · `:w` save · `:q` quit · `:wq` save+quit
- `dd` delete line · `yy` copy line · `p` paste · `u` undo · `Ctrl+r` redo
- `/text` search · `n`/`N` next/prev match
- `gcc` toggle comment (line) · `gc` in visual mode
- `Ctrl+w` then `h/j/k/l` — move between splits

## Debugging (nvim-dap — your Cursor debugger replacement)
Breakpoints + stepping via the same Debug Adapter Protocol VS Code/Cursor use.
It **auto-reads `.vscode/launch.json`**, so your snapcaster attach configs just work.

| Keys | Action |
|---|---|
| `Space b` | Toggle breakpoint (do this first) |
| `Space B` | Conditional breakpoint (prompts for an expression) |
| `F5` | Start / continue → **pick a config** (e.g. "Attach: core") |
| `F1` | Step into |
| `F2` | Step over |
| `F3` | Step out |
| `F7` | Toggle the debug UI (variables, call stack, watches, REPL) |

**Debugging a snapcaster backend service** (mirrors your Cursor flow):
1. Start the stack: `docker compose up` (add `--profile marketplace` if needed).
2. Open the service's file in nvim from `~/git/snapcaster/backend`, e.g. `nvim services/core/src/...`.
3. `Space b` on the line you care about.
4. `F5` → choose **"Attach: core"** (or projection/email/etc. — matches the compose inspector ports 9229–9236).
5. Trigger the code path; nvim stops at the breakpoint. `F7` opens the variable/stack UI.
6. `F5` again to continue, or `:DapTerminate` to detach.

## Managing the setup
- `:Mason` — install/manage language servers, formatters & **debug adapters** (UI)
- `:checkhealth` — diagnose problems
- `:e $MYVIMRC` — open your config (`~/.config/nvim/init.lua`)
- Node debug config lives in `lua/custom/plugins/debug-node.lua`

## What's installed for you
- **LSP**: `ts_ls` (TS/JS), `basedpyright` (Python), `lua_ls`
- **Formatters** (on save): `prettierd` (JS/TS/JSON/CSS/HTML/MD), `ruff` (Python), `stylua` (Lua)
- **Treesitter** syntax for JS/TS/TSX, Python, Lua, JSON, CSS, HTML, bash, markdown + more

## Adding a new language later
1. `:Mason` → find & install its language server (press `i`)
2. Add it to the `servers = { ... }` table in `init.lua`
3. Restart nvim

Your config is a git repo (`~/.config/nvim`) — commit changes as you tweak.
