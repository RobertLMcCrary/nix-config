{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/usr/local/bin"
  ];

  environment.systemPackages = with pkgs; [
    direnv
    git
    curl
    lazygit
    postgresql_18
  ];

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.meslo-lg
  ];

  # primary user
  system.primaryUser = "robertmccrary";

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

  # Local Linux builder (Apple Virtualization framework, entirely on this
  # machine) — for building/testing NixOS configs (e.g. MachineConfigurations'
  # nix/checks.nix VM tests) without routing anything through the real prod
  # build machine above. Supports both native aarch64-linux and emulated
  # x86_64-linux (MachineConfigurations' hosts are x86_64-linux).
  nix.linux-builder = {
    enable = true;
    systems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    config = {
      virtualisation = {
        cores = 4;
        memorySize = 8192; # MB
        diskSize = 51200; # MB — NixOS VM tests build a full system closure
      };
    };
  };

  system.stateVersion = 5;
}
