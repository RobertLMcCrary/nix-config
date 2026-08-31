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
      font-family = "MesloLGS Nerd Font";
      font-size = 17;
      font-thicken = true;
      font-thicken-strength = 0;
      adjust-cell-height = -2;
      theme = "0x96f";
      #theme = "Github Light Default";
      cursor-style = "block";
      cursor-style-blink = false;
      cursor-color = "#ffffff";
      #cursor-color = "#000000";
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
