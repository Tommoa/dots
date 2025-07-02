{ ... }:

{
  imports = [
    ../../common/base.nix
    ../../common/nix.nix
    ../../common/fonts.nix
  ];

  # Override packages with overlays
  nixpkgs.overlays = [
    (import ../../../overlays)
  ];

  # Keyboard settings
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Dock settings
  system.defaults.dock = {
    autohide = true;
    showhidden = true;
    show-recents = false;
  };

  system.defaults.NSGlobalDomain.ApplePressAndHoldEnabled = false;

  system.stateVersion = 5;
}
