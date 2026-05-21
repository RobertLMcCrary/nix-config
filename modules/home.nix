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

  home.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  programs.git = {
    enable = true;
    userName = "RobertLMcCrary";
    userEmail = "rlmccrary1210@gmail.com";
  };

  programs.zsh = {
    enable = true;
    oh-my-zsh = {
      enable = true;
      theme = "robbyrussell";
      plugins = [ "git" ];
    };

    shellAliases = {
      vim = "nvim";
      lg = "lazygit";
      ff = "fastfetch";
      l = "ls -l";
      y = "yazi";
    };
  };

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
      };
      modules = [
        "os"
        "host"
        "kernel"
        "uptime"
        "shell"
        "memory"
        "cpu"
        "gpu"
        "disk"
        "swap"
        "battery"
        "localip"
        "publicip"
        "separator"
        "colors"
      ];

    };
  };

  programs.yazi = {
    enable = true;
  };
}
