{ config, lib, pkgs, ... }:

{
  # Override some packages for some specific changes for macOS
  # See ~/.config/nixpkgs/overlays for the actual changes
  nixpkgs.overlays = [
    (import ../overlays)
    (self: super: {
      nodejs = super.nodejs_22;
      nodejs-slim = super.nodejs-slim_22;
    })
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
    alacritty
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
    enableScriptingAddition = true;

    config = {
      # Global settings
      mouse_follows_focus        = "on";
      focus_follows_mouse        = "autoraise";
      window_placement           = "second_child";
      window_shadow              = "on";
      window_opacity             = "off";
      window_opacity_duration    = 0.0;
      active_window_opacity      = 1.0;
      normal_window_opacity      = 0.90;
      insert_feedback_color      = "0xffd75f5f";
      split_ratio                = 0.50;
      auto_balance               = "off";
      mouse_modifier             = "cmd";
      mouse_action1              = "move";
      mouse_action2              = "resize";
      mouse_drop_action          = "swap";

      # General space
      layout                     = "bsp";
      top_padding                = 12;
      bottom_padding             = 12;
      left_padding               = 12;
      right_padding              = 12;
      window_gap                 = 06;
    };

    extraConfig = ''
      yabai -m rule --add app='System Settings' manage=off
      yabai -m rule --add app='Obsidian' space=5
      yabai -m signal --add event=dock_did_restart action="sudo yabai --load-sa"
      sudo yabai --load-sa
    '';
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
