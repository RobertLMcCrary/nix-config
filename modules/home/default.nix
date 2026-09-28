{ pkgs, lib, ... }:
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

  # Match the macOS defaults in modules/darwin.nix: each macOS key-repeat
  # unit is 15ms, while GNOME stores these values directly in milliseconds.
  dconf.settings = lib.mkIf pkgs.stdenv.isLinux {
    "org/gnome/desktop/peripherals/keyboard" = {
      delay = lib.gvariant.mkUint32 150;
      repeat-interval = lib.gvariant.mkUint32 15;
    };

    # Keep the Toughbook reachable over Tailscale while its display is idle.
    # This does not prevent screen blanking or locking; it only disables the
    # automatic system suspend that would stop networking and SSH.
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
      sleep-inactive-battery-type = "nothing";
    };
  };
}
