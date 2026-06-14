# ~/.zprofile — runs once per login shell. PATH and environment setup.
# Managed in ~/dotfiles.

# Homebrew (sets PATH, MANPATH, etc.)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Tools that install into ~/.local/bin (uv, rustup, etc.)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"

# OrbStack (containers / VMs)
source "$HOME/.orbstack/shell/init.zsh" 2>/dev/null || :

# NOTE: removed the Python 3.7 framework PATH entry that used to live here.
# Python 3.7 is end-of-life and it was shadowing Homebrew's `python3`.
