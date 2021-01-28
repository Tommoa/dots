{ config, lib, pkgs, ... }:

{
  # Override some packages for some specific changes for macOS
  # See ~/.config/nixpkgs/overlays for the actual changes
  nixpkgs.overlays = [
    (import ../overlays)
  ];

  # Packages that should be installed in the system
  environment.systemPackages = with pkgs; [
    aerc
    alacritty
    bat
    beancount
    catimg
    dante
    exa
    fd
    git
    goimapnotify
    gnupg
    isync
    jq
    khal
    khard
    less
    msmtp
    neovim
    nodejs
    notmuch
    ripgrep
    tmux
    vdirsyncer
    w3m
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

  # Use a custom configuration.nix location.
  # $ darwin-rebuild switch -I darwin-config=$HOME/.config/nixpkgs/darwin/configuration.nix
  environment.darwinConfig = "$HOME/.config/nixpkgs/darwin/configuration.nix";

  # Auto upgrade nix package
  nix.package = pkgs.nix;

  launchd.user.agents = let goimapnotifyconfs = (builtins.filter (filename: (builtins.match ".*\.conf" filename) != null) (builtins.attrNames (builtins.readDir ~/.config/imapnotify)));
  in
  builtins.listToAttrs
    (builtins.map
      (name: {
        name = "goimapnotify-${name}";
        value = {
          serviceConfig = {
            ProgramArguments = [
              "${pkgs.goimapnotify}/bin/goimapnotify"
              "-conf"
              (toString ~/.config/imapnotify + "/${name}")
            ];
            RunAtLoad = true;
            EnvironmentVariables = {
              PATH = "${pkgs.goimapnotify}/bin:${pkgs.notmuch}/bin:${pkgs.isync}/bin:${config.environment.systemPath}";
              NIX_SSL_CERT_FILE = "/etc/ssl/certs/ca-certificates.crt";
            };
            KeepAlive = true;
            ProcessType = "Background";
          };
        };
      }) goimapnotifyconfs);

  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
