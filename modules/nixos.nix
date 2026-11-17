{
  config,
  pkgs,
  zen-browser,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

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

  # Rename to match `hostnamectl hostname` on the laptop, and keep it in
  # sync with the `nixosHostName` value in flake.nix.
  networking.hostName = "nixos-laptop";
  networking.networkmanager.enable = true;

  # Private remote development from the Mac. Tailscale provides the private
  # network; OpenSSH is deliberately exposed only on its interface, never to
  # the public LAN/Internet firewall zone.
  services.tailscale.enable = true;
  services.openssh = {
    enable = true;
    openFirewall = false;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "robertmccrary" ];
    };
  };
  networking.firewall.interfaces.${config.services.tailscale.interfaceName}.allowedTCPPorts = [ 22 ];

  # Modern UEFI default. Switch to boot.loader.grub if the laptop is legacy BIOS.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # GNOME for now — switching to a tiling WM (Hyprland/i3) later is just
  # swapping this block, no reinstall needed.
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;
  programs.dconf.enable = true;
  # Always-on server for Rex/SSH over Tailscale: never sleep, whether the lid
  # closes, the machine idles, or it sits at the login screen after a reboot.
  services.logind.settings.Login = {
    IdleAction = "ignore";
    HandleLidSwitch = "ignore";
    HandleLidSwitchExternalPower = "ignore";
    HandleLidSwitchDocked = "ignore";
  };
  services.displayManager.gdm.autoSuspend = false;
  systemd.sleep.settings.Sleep = {
    AllowSuspend = "no";
    AllowHibernation = "no";
    AllowHybridSleep = "no";
    AllowSuspendThenHibernate = "no";
  };
  # Wi-Fi power saving adds latency and can drop idle remote sessions.
  networking.networkmanager.wifi.powersave = false;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.robertmccrary = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.nushell;
    # Keep the Rex user service (and its sessions) running while logged out.
    linger = true;
  };
  programs.zsh.enable = true;
  environment.shells = [ pkgs.nushell ];

  # Set once at install time to the NixOS release you installed with, then
  # never change it — see the nixos-generate-config output / release notes.
  system.stateVersion = "24.11";

  # zen
  environment.systemPackages = [
    zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
