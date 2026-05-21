{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    curl
  ];

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "robert" ];
  };

  services.nix-daemon.enable = true;
  system.stateVersion = 5;
}
