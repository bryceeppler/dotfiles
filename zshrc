# ~/.zshrc — interactive shell configuration. Managed in ~/dotfiles.

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

# --- NVM (lazy-loaded so new shells start instantly) ---
export NVM_DIR="$HOME/Library/Application Support/Herd/config/nvm"
_load_nvm() {
  unset -f nvm node npm 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}
nvm()  { _load_nvm; nvm "$@"; }
node() { _load_nvm; node "$@"; }
npm()  { _load_nvm; npm "$@"; }

# --- BUN ---
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# --- PROMPT (starship) ---
eval "$(starship init zsh)"

# --- PLUGINS ---
# brew --prefix is slow (spawns a process), so resolve it once and reuse.
# zsh-syntax-highlighting MUST be sourced LAST per its docs.
BREW_PREFIX="$(brew --prefix)"
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
