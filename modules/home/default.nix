{ ... }:
{
  imports = [
    ./packages.nix
    ./shell.nix
    ./dev.nix
    ./terminal.nix
  ];

  home.username = "robertmccrary";
  home.homeDirectory = "/Users/robertmccrary";
  home.stateVersion = "24.11";
  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };
}
