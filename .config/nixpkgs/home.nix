{ pkgs, lib ? pkgs.lib, config, ... }:

{
  options.home.enableGraphical = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Whether to enable graphical applications";
  };

  config = lib.mkMerge [
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
        neovim
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

      # Let Home Manager install and manage itself.
      programs.home-manager.enable = true;
    }
    (lib.mkIf config.home.enableGraphical (import ./common/graphical.nix { inherit pkgs lib config; }))
  ];
}
