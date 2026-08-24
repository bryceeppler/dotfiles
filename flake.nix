{
  description = "dotfiles";

  inputs = {
    # Use `github:NixOS/nixpkgs/nixpkgs-26.05-darwin` to use Nixpkgs 26.05.
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-26.05-darwin";
    # Use `github:nix-darwin/nix-darwin/nix-darwin-26.05` to use Nixpkgs 26.05.
    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-26.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    # Declarative Homebrew: nix-homebrew owns the Homebrew installation and the
    # homebrew module in configuration.nix declares a baseline package set.
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";

    # herdr terminal workspace tool; ships a nixpkgs overlay -> pkgs.herdr.
    herdr.url = "github:ogulcancelik/herdr";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, herdr }: {
    darwinConfigurations."mac" = nix-darwin.lib.darwinSystem {
      modules = [
        ./configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        {
          # Make pkgs.herdr available everywhere (herdr ships this overlay);
          # with useGlobalPkgs, home-manager sees it too.
          nixpkgs.overlays = [ herdr.overlays.default ];
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          # Back up any pre-existing file HM would replace (e.g. a manual
          # ~/.config symlink) instead of aborting activation.
          home-manager.backupFileExtension = "hm-bak";
          home-manager.users.bryceeppler = import ./home.nix;
        }
      ];
    };
  };
}
