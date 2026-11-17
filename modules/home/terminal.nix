{ pkgs, config, ... }:
{
  # nix-darwin registers fonts.packages system-wide for Font Book/apps; on
  # non-NixOS Linux there's no equivalent, so home-manager has to manage
  # fontconfig itself for the nerd font (in packages.nix) to be found.
  fonts.fontconfig.enable = pkgs.stdenv.isLinux;

  programs.ghostty = {
    enable = true;
    # On Darwin the app comes from the Homebrew cask (modules/darwin.nix);
    # null tells home-manager to just manage the config file, not install
    # the package. On Linux the regular nixpkgs build works fine.
    package = if pkgs.stdenv.isDarwin then null else pkgs.ghostty;

    enableZshIntegration = true;

    settings = {
      # Do not let a stale desktop-session $SHELL (for example, zsh) override
      # the login shell configured by NixOS/nix-darwin.
      command = "nu";
      font-family = "MesloLGS Nerd Font";
      font-size = 28;
      font-thicken = true;
      font-thicken-strength = 0;
      adjust-cell-height = -2;
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

  # A persistent remote session for Codex, Claude Code, builds, and logs.
  # `agents` (defined in shell.nix) creates it on first use and reattaches
  # thereafter, so an SSH disconnect does not stop the work inside.
  programs.tmux = {
    enable = true;
    mouse = true;
    escapeTime = 0;
    historyLimit = 100000;

    # Ctrl-a is easier to reach than the default Ctrl-b (and matches screen).
    prefix = "C-a";
    # vi-style copy mode, plus hjkl/HJKL for pane navigation and resizing.
    keyMode = "vi";
    customPaneNavigationAndResize = true;
    # Windows/panes numbered from 1, matching the number row on the keyboard.
    baseIndex = 1;

    extraConfig = ''
      # Split panes with | and - instead of the unmnemonic % and ", and
      # keep new panes/windows in the current pane's working directory.
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Reload the config in place with prefix+r instead of restarting tmux.
      bind r source-file ~/.config/tmux/tmux.conf \; display-message "tmux config reloaded"

      # Keep window numbers contiguous after one is closed.
      set -g renumber-windows on

      # A status bar that actually shows the session name and clock.
      set -g status-style "bg=#1a1b26,fg=#c0caf5"
      set -g status-left "#[bold] #S "
      set -g status-right "%H:%M  %d-%b-%y"
      set -g window-status-current-style "bold,bg=#7aa2f7,fg=#1a1b26"
    '';
  };

  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;
    shellWrapperName = "fs";
    settings = {
      opener.edit = [
        {
          run = "nvim $@";
          block = true;
        }
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
}
