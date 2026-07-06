# ~/.zshrc — interactive shell configuration. Managed in ~/.dotfiles.

# --- HISTORY ---
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zsh_history
setopt SHARE_HISTORY HIST_IGNORE_DUPS HIST_IGNORE_SPACE
setopt AUTO_CD NO_BEEP

# --- COMPLETION ---
autoload -Uz compinit && compinit
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive
zstyle ':completion:*' menu select

# --- ALIASES ---
alias py='python3'
alias vm='source ./venv/bin/activate'

# git
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gpl='git pull'
alias gco='git checkout'

# navigation / files
alias ll='ls -la'
alias ..='cd ..'

# snapcaster RabbitMQ queue manager
alias qdelete="cd $HOME/git/snapcaster/backend/scripts/queue_manager && ./venv/bin/python queue_exchange_deleter.py"
alias qpurge="cd $HOME/git/snapcaster/backend/scripts/queue_manager && ./venv/bin/python queue_purger.py"

# --- PNPM ---
export PNPM_HOME="$HOME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# --- Node (fnm: fast Rust nvm replacement; auto-switches per .node-version/.nvmrc) ---
eval "$(fnm env --use-on-cd --shell zsh)"

# --- BUN ---
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# --- PYTHON (uv owns interpreters, venvs & tools — see ~/.dotfiles/TOOLCHAIN.md) ---
eval "$(uv generate-shell-completion zsh)"
eval "$(uvx --generate-shell-completion zsh)"

# --- FZF (fuzzy finder: Ctrl-R history, Ctrl-T files, Alt-C cd into dir) ---
if command -v fzf >/dev/null; then
  source <(fzf --zsh)                 # completion + keybindings (fzf 0.48+)
  # Use fd for file/dir listings so Ctrl-T and Alt-C respect .gitignore.
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
fi

# --- PROMPT (starship) ---
eval "$(starship init zsh)"

# --- PLUGINS ---
# brew --prefix is slow (spawns a process), so resolve it once and reuse.
# zsh-syntax-highlighting MUST be sourced LAST per its docs.
BREW_PREFIX="$(brew --prefix)"
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"
