{ pkgs, ... }: {
  home.username = "robertmccrary";
  home.homeDirectory = "/Users/robertmccrary";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    go
    ripgrep
    fd
    jq
    ttyper
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
      tt = "ttyper";
    };
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      vim = "nvim";
      lg = "lazygit";
      ff = "fastfetch";
      l = "ls -l";
      y = "yazi";
      tt = "ttyper";
    };
    extraConfig = ''
      $env.config = {
        show_banner: false
      }
    '';
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      format = "$username$directory$git_branch$git_status$character";
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      directory = {
        truncation_length = 3;
        truncate_to_repo = true;
      };
      git_branch = {
        symbol = " ";
        style = "bold purple";
      };
      git_status = {
        style = "bold red";
      };
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
    settings = {
      opener = {
        edit = [
          {
            run = "nvim $@";
            block = true;
          }
        ];
      };
    };
  };
}
