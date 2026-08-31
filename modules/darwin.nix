{ pkgs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPath = [
    "/opt/homebrew/bin"
    "/usr/local/bin"
  ];

  # Most CLI dev tools (direnv, git, LSPs, ...) live in modules/home/*.nix
  # via home-manager, reproducible on NixOS/Linux too. A few tools are kept
  # on Homebrew here by choice (faster-moving CLIs, or things that don't
  # need to exist on the NixOS laptop) — modules/home/packages.nix installs
  # the Nix equivalents of these on Linux only, so they still exist there.
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # Keep "none": cool-retro-term, pidgin, gotop, htop, iftop, helix,
      # gplugin, ninja, etc. are intentionally left as manually-managed
      # Homebrew installs, not declared below. "zap"/"uninstall" would
      # remove all of them on the next activation since this config
      # doesn't know about them.
      cleanup = "none";
    };
  };

  homebrew.taps = [
    "getsentry/xcodebuildmcp"
    "sourcegraph/src-cli"
    "supabase/tap"
  ];

  homebrew.brews = [
    "dbmate"
    "elixir"
    "ffmpeg"
    "flyctl"
    "gemini-cli"
    "mkcert"
    "neovim"
    "openjdk@21"
    "postgresql@18"
    "tokei"
    "typst"
    "whisper-cpp"
    "yt-dlp"
    "getsentry/xcodebuildmcp/xcodebuildmcp" # no Nix package — Mac-only
    "sourcegraph/src-cli/src-cli"
    "supabase/tap/supabase"
  ];

  homebrew.casks = [
    "claude-code@latest"
    "codex"
    "dotnet-sdk"
    "font-meslo-lg-nerd-font"
    "gcloud-cli"
    "ghostty"
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
    # Default omits "nixos-test" — fine for ordinary package builds, but
    # NixOS VM tests (pkgs.testers.runNixOSTest, e.g. MachineConfigurations'
    # nix/checks.nix test.<host>) require it explicitly, or the final
    # vm-test-run-*.drv gets rejected with "missing system features" even
    # though everything leading up to it (including the KVM-requiring test
    # driver itself) already built fine.
    supportedFeatures = [
      "kvm"
      "benchmark"
      "big-parallel"
      "nixos-test"
    ];
    config = {
      # `systems` above only advertises x86_64-linux capability in the
      # machines-file line — it doesn't by itself register QEMU user-mode
      # emulation inside the guest. Without this, the VM only ever reports
      # itself as aarch64-linux at build time and rejects x86_64-linux
      # derivations with a platform mismatch (confirmed the hard way).
      boot.binfmt.emulatedSystems = [ "x86_64-linux" ];

      virtualisation = {
        cores = lib.mkForce 2;
        memorySize = lib.mkForce 3072; # MB
        # NixOS VM tests build a full system closure (Postgres, Zitadel,
        # Grafana, VictoriaMetrics, Traefik, ...) — the module's own 20GB
        # default is tight for that, so override rather than just add.
        diskSize = lib.mkForce 51200; # MB
      };
    };
  };

  system.stateVersion = 5;
}
