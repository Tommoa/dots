{ pkgs, ... }:

{
  # X11 and display manager
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;

  # Audio
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Printing
  services.printing.enable = true;

  # Desktop programs
  programs.firefox.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
    extraPackages = with pkgs; [
      alacritty
      brightnessctl
      grim
      mako
      pavucontrol
      playerctl
      swayidle
      swaylock
      wl-clipboard
      wlsunset
      wob
      wofi
    ];
  };
  programs.waybar.enable = true;

  # Gaming
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];

  # Environment variables
  environment.sessionVariables.NIXOS_OZONE_WL = "1";
}
