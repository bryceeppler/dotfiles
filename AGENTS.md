# Project agent memory

This file is the project's committed home for project-intrinsic agent knowledge: build, test, release, architecture, and sharp-edge notes that should travel with the code.

- Add durable project-specific notes here as they are discovered through real work.

## Shell PATH: interactive vs non-interactive

`~/.zshenv` is home-manager-managed and sourced by *every* zsh (including non-interactive `zsh -c ...`).
It sources `hm-session-vars.sh`, which is where `home.sessionVariables` and `home.sessionPath` land.
The nix profile bin dirs (`/etc/profiles/per-user/<user>/bin`, `/run/current-system/sw/bin`) are only added by the login/interactive init (`/etc/zprofile`, `/etc/zshrc`), which non-interactive non-login shells never read.
So any CLI those shells need from profile-specific paths must go through `home.sessionPath` in `home.nix`, not `programs.zsh.initContent` (interactive-only) - the directly installed Herdr binary in `~/.local/bin` is one example.
`path` is `typeset -U`, so duplicate dirs are de-duplicated automatically.
