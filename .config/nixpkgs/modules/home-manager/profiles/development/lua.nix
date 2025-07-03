{ pkgs, ... }:

{
  home.packages = with pkgs; [
    luajit
    sumneko-lua-language-server
  ];
}
