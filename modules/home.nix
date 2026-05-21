{ pkgs, ... }: {
  home.username = "robertmccrary";
  home.homeDirectory = "/Users/robertmccrary";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    go
    ripgrep
    fd
    jq
  ];

  programs.git = {
    enable = true;
    userName = "RobertLMcCrary";
    userEmail = "rlmccrary1210@gmail.com";
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussel";
      plugins = [ "git" ];
    };
  };
}
