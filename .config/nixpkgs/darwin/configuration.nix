{ config, lib, pkgs, ... }:

{
  nixpkgs.overlays = [
    (import ../overlays)
  ];
  nixpkgs.config.allowUnsupportedSystem = true;
  environment.systemPackages = [
    pkgs.aerc
    pkgs.alacritty
    pkgs.bat
    pkgs.beancount
    pkgs.catimg
    pkgs.dante
    pkgs.exa
    pkgs.fd
    pkgs.git
    pkgs.goimapnotify
    pkgs.gnupg
    pkgs.isync
    pkgs.jq
    pkgs.khal
    pkgs.khard
    pkgs.less
    pkgs.msmtp
    pkgs.neovim
    pkgs.nodejs
    pkgs.notmuch
    pkgs.ripgrep
    pkgs.tmux
    pkgs.vdirsyncer
    pkgs.w3m
  ];

  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  system.defaults.dock = {
    autohide = true;
    showhidden = true;
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

  # Auto upgrade nix package and the daemon service.
  # services.nix-daemon.enable = true;
  nix.package = pkgs.nix;

  launchd.user.agents = let goimapnotifyconfs = (builtins.filter (filename: (builtins.match ".*\.conf" filename) != null) (builtins.attrNames (builtins.readDir ~/.config/imapnotify)));
  in
  builtins.listToAttrs
    (builtins.map
      (name: {
        name = "goimapnotify${name}";
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
          };
        };
      }) goimapnotifyconfs);

  programs.zsh.enable = true;

  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;
}
