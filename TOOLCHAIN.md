# Toolchain — Node, package managers & global CLIs

Cleaned up 2026-06. Guiding principle: **Homebrew owns apps/CLIs, never language
runtimes.** Node is owned by **fnm**; package managers come from **corepack**,
pinned per project. One source of truth per tool — no more drift.

## Who owns what

| Tool | Owner | Notes |
|------|-------|-------|
| Node | **fnm** | `eval "$(fnm env --use-on-cd --shell zsh)"` in `zshrc`; auto-switches on `.node-version`/`.nvmrc` |
| npm | bundled with fnm's Node | |
| pnpm / yarn | **corepack** | shims live in fnm's node bin; pin per project via the `packageManager` field |
| bun, deno | **Homebrew** | upgrade with `brew upgrade` — do **not** run `bun upgrade` (that's what caused version drift before) |
| claude, codex | native installers → `~/.local/bin` | self-updating, Node-independent |
| railway | npm global under fnm | `npm i -g @railway/cli` |
| vercel, wrangler, @shopify/cli, @nestjs/cli | **pnpm global** (`~/Library/pnpm`) | `pnpm add -g` / `pnpm update -g` |
| gh, stripe, heroku, twilio, pscale, … | **Homebrew** | |

## Python (uv)

uv owns Python end-to-end — no pyenv / conda / poetry / pipx. Homebrew keeps Python
only as a dependency of its own formulae (ffmpeg, httpie, libass, …); never use those for dev.

| Need | Command |
|------|---------|
| Install an interpreter | `uv python install 3.13` |
| Pin per project | `uv python pin 3.13` (writes `.python-version`) |
| Make a venv | `uv venv` → `.venv` |
| Run without activating | `uv run script.py` / `uv run pytest` |
| Add deps to a project | `uv add <pkg>` (ad-hoc: `uv pip install`) |
| Global Python CLI (pipx replacement) | `uv tool install <pkg>` / one-off: `uvx <pkg>` |
| Update uv | `uv self update` |

**Don't** `brew install python@x` for dev, `pip install --user`, or hand-roll venvs from a
brew python. `python@3.11` is kept *only* because two older venvs (`~/git/scripts`,
`~/git/snapcaster/backend/scraper/v3`) were built on it — migrate them to uv
(`uv venv && uv pip install -r requirements.txt`) and it can be removed too.
Apple's `/usr/bin/python3` is system-managed — leave it.

## Per-project setup (preferred over anything global)

- **Pin Node:** drop a `.node-version` file (e.g. `24`) in the repo. fnm switches on `cd`.
- **Pin package manager:** in `package.json`, `"packageManager": "pnpm@<ver>"`. corepack enforces it.
- **One-off CLI:** `pnpm dlx <pkg>` or `npx <pkg>` — install nothing globally.

## Adding a new global CLI — decision order

1. Run it once? → `pnpm dlx` / `npx`, install nothing.
2. Standalone app with its own self-updating installer? → use that (lands in `~/.local/bin`).
3. Maintained brew formula and not a JS lib? → `brew install`.
4. JS CLI used across many projects? → `pnpm add -g`.

**Never:** `npm i -g` into a brew Node, a nodejs.org `.pkg`, or a second version manager.

## Upgrade routine (~monthly)

```sh
# Homebrew apps
brew update && brew upgrade && brew autoremove && brew cleanup
brew outdated            # see what's pending
brew leaves              # top-level installs (the list you actually chose)

# Node: install the new LTS, make it default, drop the old one
fnm install --lts && fnm default <new-lts>
fnm ls && fnm uninstall <old-version>

# Package managers (corepack)
corepack install -g pnpm@latest      # global default pnpm
# or per-project:  corepack use pnpm@latest   (writes packageManager field)

# Global pnpm CLIs
pnpm update -g

# Self-updating standalones
claude update    # codex updates itself on launch
```

## Health check

```sh
# Each of these should resolve to ONE place (fnm / ~/.local/bin / pnpm / brew):
for c in node npm pnpm yarn bun deno claude codex railway vercel wrangler shopify; do
  printf '%-9s %s\n' "$c" "$(command -v "$c")"
done
which -a node            # should show only the fnm shim
```
