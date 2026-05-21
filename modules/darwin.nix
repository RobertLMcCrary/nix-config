{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    curl
  ];

  # primary user
  system.primaryUser = "robertmccrary";

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    trusted-users = [ "root" "robert" ];
  };

  system.stateVersion = 5;
}
