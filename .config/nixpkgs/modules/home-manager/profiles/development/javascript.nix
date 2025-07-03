{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs
    typescript
    typescript-language-server
  ];
}
