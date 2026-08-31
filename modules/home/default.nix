{ pkgs, ... }:
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./dev.nix
    ./terminal.nix
  ];

  home.username = "robertmccrary";
  home.homeDirectory = if pkgs.stdenv.isDarwin then "/Users/robertmccrary" else "/home/robertmccrary";
  home.stateVersion = "24.11";
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  xdg.enable = true;
}
