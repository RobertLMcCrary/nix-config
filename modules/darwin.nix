{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    git
    curl
    lazygit
  ];

  # primary user
  system.primaryUser = "robertmccrary";

  #homebrew
  homebrew = {
    enable = true;
    casks = [
      "font-meslo-lg-nerd-font"
      "claude-code"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };
  };

  services.postgresql = {
    enable = true;
    package = pkgs.postgresql;
    dataDir = "/var/lib/postgresql/nudox";
    ensureDatabases = [ "nudox_dev" ];
    ensureUsers = [
      {
        name = "robertmccrary";
        ensureDBOwnership = true;
      }
    ];

  };

  system.defaults = {
    dock = {
      autohide = true;
      autohide-delay = 0.0;
      autohide-time-modifier = 0.2;
      show-recents = false;
      minimize-to-application = true;
      orientation = "bottom";
    };

    finder = {
      AppleShowAllExtensions = true;
      AppleShowAllFiles = true;
      ShowPathbar = true;
      ShowStatusBar = true;
      FXDefaultSearchScope = "SCcf"; # search current folder by default
    };

    NSGlobalDomain = {
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      ApplePressAndHoldEnabled = false;
    };

    trackpad = {
      Clicking = true; # tap to click is a w
      TrackpadThreeFingerDrag = true;
      TrackpadThreeFingerTapGesture = 2;
      TrackpadRightClick = true;
    };

    screencapture = {
      location = "~/Pictures";
      type = "png";
    };
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
    ];
    trusted-users = [
      "root"
      "robertmccrary"
    ];
  };

  system.stateVersion = 5;
}
