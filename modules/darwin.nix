{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    direnv
    git
    curl
    lazygit
  ];

  # primary user
  system.primaryUser = "robertmccrary";

  #homebrew
  homebrew = {
    enable = true;
    brews = [
      "postgresql@18"
    ];
    casks = [
      "font-meslo-lg-nerd-font"
      "claude-code"
    ];
    onActivation = {
      autoUpdate = true;
      cleanup = "none";
    };
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

  nix.distributedBuilds = true;
  nix.buildMachines = [
    {
      hostName = "87.99.136.215";
      system = "x86_64-linux";
      sshUser = "root";
      sshKey = "/etc/nix/builder_key";
      maxJobs = 4;
      supportedFeatures = [
        "nixos-test"
        "benchmark"
        "big-parallel"
        "kvm"
      ];
    }
  ];

  system.stateVersion = 5;
}
