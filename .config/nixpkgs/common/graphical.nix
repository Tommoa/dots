{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    # terminal + editing
    alacritty
    
    # applications
    obsidian
    spotify
    
    # messaging
    caprine
    discord
    (if lib.strings.hasInfix "linux" pkgs.system then whatsapp-for-linux else whatsapp-for-mac)
  ];

  gtk = {
    enable = pkgs.lib.strings.hasInfix "linux" pkgs.system;
    iconTheme = {
      name = "Pop-dark";
      package = pkgs.pop-icon-theme;
    };
    cursorTheme = {
      name = "Pop";
      package = pkgs.pop-gtk-theme;
    };
    theme = {
      name = "Pop-dark";
      package = pkgs.pop-gtk-theme;
    };
  };
}