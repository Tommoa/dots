{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Standard terminal tools.
    bat
    eza
    fd
    git
    gnupg
    gnumake
    jq
    ripgrep
    tmux

    # language support
    clang
    nodejs
    python3
    rustup
    typescript
    uv
    # language servers
    pyright
    nixd
    sumneko-lua-language-server
    typescript-language-server
    # AI servers/helpers
    codex
    ollama
    opencode

    # terminal + editing
    alacritty
    neovim

    # applications
    obsidian

    # messaging
    caprine
    discord
    (if lib.strings.hasInfix "linux" pkgs.system then whatsapp-for-linux else whatsapp-for-mac)
  ];

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";

  gtk = {
    enable = true;
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

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
