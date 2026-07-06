# ~/.zprofile — runs once per login shell. PATH and environment setup.
# Managed in ~/.dotfiles.

# Homebrew (sets PATH, MANPATH, etc.)
eval "$(/opt/homebrew/bin/brew shellenv)"

# Tools that install into ~/.local/bin (uv, rustup, etc.)
[ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"