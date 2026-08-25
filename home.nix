{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
    preferDirectInstallPath = ''
        path=("$HOME/.local/bin" ''${path:#"$HOME/.local/bin"})
    '';
in
{
    home = {
        username = "bryceeppler";
        homeDirectory = "/Users/bryceeppler";
        stateVersion = "26.05";
        packages = with pkgs; [
            # User-space tools we use
            neovim
            stripe-cli   # was a third-party brew tap; nixpkgs is cleaner + newer
        ];
    };

    home.sessionVariables.EDITOR = "nvim";

    # Put the nix profile bins on PATH for *every* zsh, including non-interactive
    # non-login shells. The login/interactive init (/etc/zprofile, /etc/zshrc) is
    # where nix-darwin normally adds these, but a `zsh -c ...` launched outside a
    # login shell never reads those files - so the bins would be missing.
    # home.sessionPath is written into hm-session-vars.sh, which
    # the home-manager-managed ~/.zshenv sources on every zsh, so it covers them.
    #
    #   ~/.local/bin                           -> directly installed CLIs (Herdr)
    #   /etc/profiles/per-user/<user>/bin  -> home-manager profile
    #   /run/current-system/sw/bin         -> nix-darwin system profile
    #
    # These are prepended ahead of the inherited PATH but sourced before ~/.zshenv's
    # cargo/homebrew/pnpm setup runs, so those user tools still take precedence in
    # interactive shells (matching current behaviour). PATH is `typeset -U`, so an
    # already-present dir is de-duplicated rather than shadowing anything.
    home.sessionPath = [
        "${config.home.homeDirectory}/.local/bin"
        "/etc/profiles/per-user/${config.home.username}/bin"
        "/run/current-system/sw/bin"
    ];

    # Skip the home-manager options manpage: silences the nixpkgs
    # 'options.json ... without a proper context' warning and trims rebuilds.
    # (Lose `man home-configuration.nix`, which we never use.)
    manual.manpages.enable = false;

    # Edit-in-place: the real files stay in my repo... ~/.config just points here.
    home.file.".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
    home.file.".config/tmux".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/tmux";
    home.file.".config/herdr".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
    home.file.".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
    home.file.".config/theme-switcher".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/theme-switcher";

    # ── Zsh ────────────────────────────────────────────────────────────────
    # Declarative zsh, replacing the hand-symlinked zshrc/zshenv/zprofile.
    # home-manager generates ~/.zshrc etc. and sources the plugins from nixpkgs,
    # so zsh-autosuggestions / zsh-syntax-highlighting leave the Brewfile.
    programs.zsh = {
        enable = true;
        autocd = true;                    # setopt AUTO_CD
        enableCompletion = true;          # runs compinit for us
        autosuggestion.enable = true;     # was: brew zsh-autosuggestions
        syntaxHighlighting.enable = true; # was: brew zsh-syntax-highlighting (auto-sourced last)

        history = {
            size = 10000;                 # HISTSIZE
            save = 10000;                 # SAVEHIST
            path = "${config.home.homeDirectory}/.zsh_history";
            share = true;                 # SHARE_HISTORY
            ignoreDups = true;            # HIST_IGNORE_DUPS
            ignoreSpace = true;           # HIST_IGNORE_SPACE
        };

        shellAliases = {
            py = "uv run python";              # uv owns Python; run in an ephemeral env
            vm = "source .venv/bin/activate";  # uv creates .venv (dot), not venv
            g = "git";
            gs = "git status";
            ga = "git add";
            gc = "git commit";
            gp = "git push";
            gpl = "git pull";
            gco = "git checkout";
            ll = "ls -la";
            ".." = "cd ..";
            qdelete = "cd ${config.home.homeDirectory}/git/snapcaster/backend/scripts/queue_manager && ./venv/bin/python queue_exchange_deleter.py";
            qpurge = "cd ${config.home.homeDirectory}/git/snapcaster/backend/scripts/queue_manager && ./venv/bin/python queue_purger.py";
        };

        # ~/.zshenv - runs for every zsh; keep minimal.
        envExtra = ''
            . "$HOME/.cargo/env"
            # Direct installers own these tools, so keep them ahead of package managers.
            ${preferDirectInstallPath}
        '';

        # ~/.zprofile - login shells: PATH / environment setup.
        profileExtra = ''
            eval "$(/opt/homebrew/bin/brew shellenv)"
            [ -f "$HOME/.local/bin/env" ] && . "$HOME/.local/bin/env"
        '';

        # ~/.zshrc body - interactive setup that isn't a first-class HM option.
        initContent = ''
            setopt NO_BEEP
            zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # case-insensitive
            zstyle ':completion:*' menu select

            # pnpm
            export PNPM_HOME="$HOME/Library/pnpm"
            case ":$PATH:" in
              *":$PNPM_HOME:"*) ;;
              *) export PATH="$PNPM_HOME:$PATH" ;;
            esac

            # Node (fnm, auto-switches per .node-version/.nvmrc)
            eval "$(fnm env --use-on-cd --shell zsh)"

            # bun
            [ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

            # Python completions (uv owns interpreters/venvs - see TOOLCHAIN.md)
            eval "$(uv generate-shell-completion zsh)"
            eval "$(uvx --generate-shell-completion zsh)"

            # libpq (postgres client tools)
            export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

            # Reassert direct-install precedence after interactive PATH setup.
            ${preferDirectInstallPath}
        '';
    };

    # fzf: shell integration + fd-backed listings, from nixpkgs (replaces the
    # manual init and drops fzf from the Brewfile).
    programs.fzf = {
        enable = true;
        defaultCommand = "fd --type f --hidden --follow --exclude .git";
        fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";       # Ctrl-T
        changeDirWidgetCommand = "fd --type d --hidden --follow --exclude .git";  # Alt-C
    };

    # starship prompt: the module wires up the zsh init; settings are imported
    # from the repo's starship.toml so it stays the single editable source
    # (starship comes from nixpkgs now, dropping it from the Brewfile).
    programs.starship = {
        enable = true;
        settings = builtins.fromTOML (builtins.readFile ./starship.toml);
    };
}
