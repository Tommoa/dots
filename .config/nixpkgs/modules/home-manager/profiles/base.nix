{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Standard terminal tools
    bat
    eza
    fd
    git
    gnupg
    gnumake
    jq
    ripgrep
    tmux

    # Terminal editing
    neovim

    # Nix
    lix
  ];

  home.stateVersion = "25.05";
  programs.home-manager.enable = true;
}
