{ pkgs, ... }:

{
  programs.zsh.enable = true;

  # Basic programs
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    neovim
  ];
}
