{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Language support
    clang
    nodejs
    python3
    rustup
    typescript
    uv

    # Language servers
    pyright
    nixd
    sumneko-lua-language-server
    typescript-language-server

    # AI servers/helpers
    codex
    ollama
    opencode
  ];
}