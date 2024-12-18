{ config, lib, pkgs, ... }:

{
  # Override some packages for some specific changes for macOS
  # See ~/.config/nixpkgs/overlays for the actual changes
  nixpkgs.overlays = [
    (import ../overlays)
  ];
  nixpkgs.config.allowUnfree = true;

  # Packages that should be installed in the system
  environment.systemPackages = with pkgs; let
    pkgpy = python3.buildEnv.override {
      extraLibs = [ beancount fava python3Packages.pip ];
      permitUserSite = true;
    };
  in
  [
    # stdutils
    bat
    eza
    fd
    gitFull
    gnupg
    jq
    ripgrep
    tmux

    # language support
    nodejs
    rustup
    # language servers
    pyright
    nixd
    sumneko-lua-language-server

    # terminal + editing
    kitty
    neovim

    # accounting
    beancount
    fava
    pkgpy

    # applications
    obsidian
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults.dock = {
    autohide = true;
    showhidden = true;
    show-recents = false;
  };

  services.yabai = {
    enable = true;
    package = pkgs.yabai;
    # enableScriptingAddition = true;
  };

  services.skhd = {
    enable = true;
    package = pkgs.skhd;
  };

  services.nix-daemon.enable = true;

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package
  nix.package = pkgs.lix;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.zsh.enable = true;

  nix.configureBuildUsers = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 5;
}
