{ config, pkgs, ... }:

let
    dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
    home = {
        username = "bryceeppler";
        homeDirectory = "/Users/bryceeppler";
        stateVersion = "26.05";
        packages = with pkgs; [
            # User-space tools we use
            neovim
            nerd-fonts.hack
        ];
    };

    fonts.fontconfig.enable = true;
    home.sessionVariables.EDITOR = "nvim";
    
    # Edit-in-place: the real file stays in my repo... ~/.config just points here.
    home.file.".config/wezterm".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
}