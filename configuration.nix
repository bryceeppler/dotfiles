{ ... }:

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

	# Declarative Homebrew. This list is the single source of truth: with
	# cleanup = "zap" below, anything installed via brew that is NOT listed
	# here is uninstalled (and its leftover files zapped) on every rebuild.
	# Dependencies of listed packages are kept automatically - only declare
	# top-level formulae (brew leaves) and casks.
	homebrew = {
		enable = true;
		onActivation = {
			cleanup = "zap";          # remove anything not listed here
			autoUpdate = true;
			extraFlags = [ "--force" ];
		};

		# No taps required: every formula below is from homebrew/core and every
		# cask from homebrew/cask. Add "owner/repo" entries here if that changes.
		taps = [ ];

		brews = [
			"btop"
			"bun"
			"ccache"
			"cmake"
			"fd"
			"ffmpeg"
			"flac"
			"fnm"
			"fzf"
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
			"neovim"
			"ninja"
			"ripgrep"
			# ffmpeg needs this for ffplay; declared explicitly because brew
			# bundle's zap cleanup doesn't follow the "sdl2" alias into its
			# keep-set and would otherwise remove it.
			"sdl2-compat"
			"starship"
			"tesseract"
			"tmux"
			"tree"
			"wget"
			"zsh-autosuggestions"
			"zsh-syntax-highlighting"
		];

		casks = [
			"hammerspoon"
			"jordanbaird-ice"
			"ngrok"
			"opensuperwhisper"
			"wezterm"
		];
	};
}
