{ pkgs, ... }: {
  home.username = "robertmccrary";
  home.homeDirectory = "/Users/robertmccrary";
  home.stateVersion = "24.11";

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    ttyper

    #go
    go

    #js / ts
    nodejs
    typescript

    #rust
    rustup

    #nix tools
    nixd
    nixfmt-rfc-style

    #lua
    lua
    lua-rocks

    #general
    gcc
    pkg-config
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

  programs.ghostty = {
    enable = true;
    #package = if pkgs.stdenv.isDarwin then pkgs.ghostty-bin else pkgs.ghostty;
    package = pkgs.ghostty-bin;

    #shells
    enableZshIntegration = true;

    settings = {
      font-family = "MesloLGS Nerd Font";
      font-size = 20;
      font-thicken = true;
      font-thicken-strength = 0;
      adjust-cell-height = -2;
      theme = "0x96f";
      cursor-style = "block";
      cursor-style-blink = false;
      cursor-color = "#ffffff";
      mouse-hide-while-typing = true;
      term = "xterm-256color";
      shell-integration-features = "no-cursor";
      scrollback-limit = 10000000;
      confirm-close-surface = false;
      window-save-state = "always";
      keybind = [
        "super+\\=new_split:right"
        "super+/=new_split:down"
        "super+j=goto_split:bottom"
        "super+k=goto_split:top"
        "super+h=goto_split:left"
        "super+l=goto_split:right"
        "super+shift+h=resize_split:left,20"
        "super+shift+j=resize_split:down,15"
        "super+shift+k=resize_split:up,15"
        "super+shift+l=resize_split:right,20"
        "super+r=reload_config"
        "super+shift+[=previous_tab"
        "super+shift+]=next_tab"
        "super+t=new_tab"
        "super+w=close_surface"
      ];
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
        "font"
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
