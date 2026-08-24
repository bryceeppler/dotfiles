{ pkgs, ... }:

{
	# Determinate Nix already manages the Nix Daemon, so nix-darwin shouldn't.
	nix.enable = false;

	nixpkgs.config.allowUnfree = true;
	nixpkgs.hostPlatform = "aarch64-darwin";

	system.primaryUser = "bryceeppler";
	users.users.bryceeppler = {
		home = "/Users/bryceeppler";
	};
	system.stateVersion = 6;

	# Authorize sudo with Touch ID (handy for a terminal-heavy setup; works in
	# tmux via the pam_reattach that Determinate/nix-darwin wires up).
	security.pam.services.sudo_local.touchIdAuth = true;

	# Login shells need this so nix + home-manager per-user paths land on PATH
	# (nix-darwin installs /etc/zshrc when enabled). Companion to the zsh config
	# in home.nix.
	programs.zsh.enable = true;

	# Fonts installed system-wide so macOS (and WezTerm) can discover them.
	# home-manager's home.packages does NOT register fonts with macOS Core Text;
	# nix-darwin's fonts.packages links them where the OS looks. FiraCode matches
	# what wezterm.lua asks for ("FiraCode Nerd Font Mono").
	fonts.packages = [ pkgs.nerd-fonts.fira-code ];

	# All values below mirror this machine's live `defaults` at the time of
	# writing, so a rebuild is idempotent rather than a surprise.
	system.defaults = {
		NSGlobalDomain = {
			AppleInterfaceStyle = "Dark";

			# Fast key repeat with a short initial delay.
			KeyRepeat = 2;
			InitialKeyRepeat = 15;
			# Disable the press-and-hold accent popup so a held key repeats.
			ApplePressAndHoldEnabled = false;

			AppleShowAllExtensions = true;
			_HIHideMenuBar = true; # auto-hide the menu bar

			# Keep spell-check and auto-capitalization, but no automatic period
			# on double-space.
			NSAutomaticPeriodSubstitutionEnabled = false;

			# Traditional scroll direction (natural scrolling off).
			"com.apple.swipescrolldirection" = false;
		};

		dock = {
			autohide = true;
			tilesize = 128;              # large Dock icons
			show-recents = false;        # no recent apps in the Dock
			minimize-to-application = true;  # minimize into the app icon
			wvous-br-corner = 14;        # bottom-right hot corner: Quick Note
		};

		finder = {
			FXPreferredViewStyle = "Nlsv"; # list view by default
			CreateDesktop = false;         # clean desktop (hide icons)
			ShowPathbar = true;
			ShowStatusBar = true;
			FXDefaultSearchScope = "SCcf"; # search the current folder, not the Mac
		};
	};

	# nix-homebrew owns the Homebrew installation itself.
	nix-homebrew = {
		enable = true;
		user = "bryceeppler";
		# Adopt the Homebrew that is already installed on this machine on the
		# first switch; without this, activation aborts because /opt/homebrew
		# exists but is not yet nix-homebrew managed.
		autoMigrate = true;
	};

	# Additive declarative Homebrew. Rebuilds install anything listed here that
	# is missing, but leave existing and undeclared packages alone. Updates stay
	# under explicit `brew` commands or each application's self-updater.
	# Dependencies of listed packages are kept automatically - only declare
	# top-level formulae (brew leaves) and casks.
	homebrew = {
		enable = true;
		onActivation = {
			cleanup = "none";
			autoUpdate = false;
			upgrade = false;
		};

		# ngrok's cask comes from the ngrok/ngrok tap, so keep it available.
		taps = [ "ngrok/ngrok" ];

		brews = [
			"btop"
			"bun"
			"ccache"
			"cmake"
			"fd"
			"ffmpeg"
			"flac"
			"fnm"
			"gh"
			"git"
			"git-lfs"
			"gnu-getopt"
			"graphviz"
			"grep"
			"httpie"
			"imagemagick"
			"jq"
			"lazygit"
			"libpq"
			"librist"
			"libvorbis"
			"mysql-client"
			"ninja"
			"ripgrep"
			"tesseract"
			"tmux"
			"tree"
			"wget"
		];

		casks = [
			"google-chrome"
			"hammerspoon"
			"jordanbaird-ice"
			"ngrok"
			"opensuperwhisper"
			"wezterm"
		];
	};
}
