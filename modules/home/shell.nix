{ pkgs, config, ... }:
{
  home.shell.enableNushellIntegration = true;

  programs.lazygit = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.zsh = {
    enable = true;
    sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };
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
      y = "fs";
      tt = "ttyper";
      cc = "claude"; # claude code
      please = "sudo";
    };
  };

  programs.nushell = {
    enable = true;

    package = pkgs.nushell;

    extraEnv = ''
      $env.PATH = [
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/run/current-system/sw/bin"
        "/etc/profiles/per-user/${config.home.username}/bin"
        "/Users/${config.home.username}/.nix-profile/bin"
        "/nix/var/nix/profiles/default/bin"
        "/usr/local/bin"
        "/usr/bin"
        "/bin"
        "/usr/sbin"
        "/sbin"
      ]
    '';

    plugins = [
      pkgs.nushellPlugins.query
      pkgs.nushellPlugins.formats
    ];

    shellAliases = {
      vim = "nvim";
      lg = "lazygit";
      ff = "fastfetch";
      y = "fs";
      tt = "ttyper";
      cc = "claude";
      please = "sudo";
    };

    environmentVariables = {
      PROMPT_INDICATOR = "";
      PROMPT_INDICATOR_VI_NORMAL = "";
      PROMPT_INDICATOR_VI_INSERT = "";
      PROMPT_MULTILINE_INDICATOR = "";
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    settings = {
      show_banner = false;
      edit_mode = "vi";

      history = {
        max_size = 100000000;
        sync_on_enter = true;
        file_format = "sqlite";
        isolation = true;
      };

      table = {
        show_empty = true;
        index_mode = "never";
      };

      cursor_shape = {
        vi_insert = "line";
        vi_normal = "block";
        emacs = "line";
      };

      keybindings = [
        {
          name = "abbr_menu";
          modifier = "none";
          keycode = "enter";
          mode = [
            "emacs"
            "vi_normal"
            "vi_insert"
          ];
          event = [
            {
              send = "menu";
              name = "abbr_menu";
            }
            { send = "enter"; }
          ];
        }
        {
          name = "accept_abbr";
          modifier = "control";
          keycode = "char_y";
          mode = [
            "emacs"
            "vi_normal"
            "vi_insert"
          ];
          event = [
            { send = "HistoryHintComplete"; }
          ];
        }
        {
          name = "fuzzy_file";
          modifier = "control";
          keycode = "char_f";
          mode = [
            "emacs"
            "vi_normal"
            "vi_insert"
          ];
          event = {
            send = "executehostcommand";
            cmd = "commandline edit --insert (fd --type file | lines | input list --fuzzy 'Select file')";
          };
        }
        {
          name = "fuzzy_history";
          modifier = "control";
          keycode = "char_r";
          mode = [
            "emacs"
            "vi_normal"
            "vi_insert"
          ];
          event = {
            send = "executehostcommand";
            cmd = "commandline edit --insert (history | get command | uniq | where {($in | str length) < 150} | input list --fuzzy 'Select entry')";
          };
        }
        {
          name = "abbr_menu";
          modifier = "none";
          keycode = "space";
          mode = [
            "emacs"
            "vi_normal"
            "vi_insert"
          ];
          event = [
            {
              send = "menu";
              name = "abbr_menu";
            }
            {
              edit = "insertchar";
              value = " ";
            }
          ];
        }
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableZshIntegration = false;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      format = "$fill\n$directory$status$git_branch$git_status$git_state$git_metrics$git_commit$character";
      right_format = "$time";
      command_timeout = 200;

      time = {
        disabled = false;
        format = "[\\[$time\\]]($style) ";
        time_format = "%H:%M:%S";
        style = "default";
      };

      fill = {
        symbol = "━";
        style = "dimmed white";
      };

      character = {
        success_symbol = "[\n(ง •̀_•́)ง](purple)";
        error_symbol = "[\n(ノಠ益ಠ)ノ彡](red)";
        vimcmd_symbol = "[◈](bold green)";
        vimcmd_replace_one_symbol = "[◆](bold purple)";
        vimcmd_replace_symbol = "[◆](bold purple)";
        vimcmd_visual_symbol = "[◉](bold yellow)";
      };

      python = {
        symbol = "";
        format = "[($virtualenv) ]($style)";
        style = "white";
      };
      nodejs = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };
      rust = {
        symbol = "";
        format = "[[ $symbol( $version) ]]($style)";
      };
      golang = {
        symbol = "";
        format = "[ $symbol( $version) ]($style)";
      };
      php = {
        symbol = "";
        format = "[[ $symbol( $version) ]]($style)";
      };
      java = {
        symbol = " ";
        format = "[[ $symbol( $version) ]]($style)";
      };
      kotlin = {
        symbol = "";
        format = "[[ $symbol( $version) ]]($style)";
      };
      haskell = {
        symbol = "";
        format = "[[ $symbol( $version) ]]($style)";
      };

      directory = {
        style = "blue";
        truncation_length = 2;
        truncation_symbol = "";
        fish_style_pwd_dir_length = 1;
        substitutions = {
          "Documents" = "󰈙 ";
          "Downloads" = " ";
          "Music" = " ";
          "Pictures" = " ";
          "Mail" = "󰇮 ";
          "Movies" = "󰿎 ";
          "Finance" = "󰏲 ";
          "Projects" = "󰲋 ";
        };
      };

      git_status = {
        untracked = "[ $count](fg:green bg:black)";
        stashed = "[ 󰜦$count](fg:cyan bg:black)";
        deleted = "[ -$count](fg:red bg:black)";
        modified = "[ 󰜥$count](fg:#fa881e bg:black)";
        renamed = "[ 󰑕$count](fg:blue bg:black)";
        staged = "[ 󰐖$count](fg:green bg:black)";
        conflicted = "[ $count](fg:red bg:black)";
        diverged = "[ 󰞇$count](fg:red bg:black)";
        ahead = "[ 󰶣$count](fg:cyan bg:black)";
        behind = "[ 󰶡$count](fg:yellow bg:black)";
        style = "bg:black";
        format = "[($ahead_behind$conflicted$stashed$staged$untracked$renamed$modified$deleted )]($style)";
      };

      git_state = {
        style = "fg:yellow bold bg:black";
        format = " \\([$state( $progress_current/$progress_total)]($style)\\)";
      };

      git_commit = {
        style = "fg:purple bg:black bold";
        only_detached = true;
        format = " [ $hash]($style)";
      };

      git_branch = {
        only_attached = true;
        style = "fg:purple bg:black bold";
        format = " [ $branch]($style)";
        ignore_branches = [
          "main"
          "master"
          "canonical"
          "trunk"
        ];
      };

      git_metrics = {
        disabled = false;
        format = "([\\(](fg:bright-black bg:black)[(+$added)](fg:green bg:black)[/](fg:bright-black bg:black)[(-$deleted)](fg:red bg:black)[\\)](fg:bright-black bg:black))";
      };

      os.symbols = {
        Windows = "󰍲";
        Ubuntu = "󰕈";
        SUSE = "";
        Raspbian = "󰐿";
        Mint = "󰣭";
        Macos = " ";
        Manjaro = "";
        Linux = "󰌽";
        Gentoo = "󰣨";
        Fedora = "󰣛";
        Alpine = "";
        Amazon = "";
        Android = "";
        Arch = "󰣇";
        Artix = "󰣇";
        CentOS = "";
        Debian = "󰣚";
        Redhat = "󱄛";
        RedHatEnterprise = "󱄛";
      };

      cmd_duration = {
        format = "[$duration]($style) ";
      };

      line_break.disabled = true;

      status = {
        disabled = false;
        pipestatus = true;
        format = "[$symbol$int]($style) ";
        symbol = "E=";
        pipestatus_format = "[\$pipestatus]($style)";
      };
    };
  };
}
