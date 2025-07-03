{ pkgs, ... }:

{
  home.packages = with pkgs; [
    codex
    ollama
    opencode
  ];
}
