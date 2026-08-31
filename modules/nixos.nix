{ pkgs, ... }:
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

  # Modern UEFI default. Switch to boot.loader.grub if the laptop is legacy BIOS.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "America/Chicago";
  i18n.defaultLocale = "en_US.UTF-8";

  users.users.robertmccrary = {
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "networkmanager"
    ];
    shell = pkgs.zsh;
  };
  programs.zsh.enable = true;

  # Set once at install time to the NixOS release you installed with, then
  # never change it — see the nixos-generate-config output / release notes.
  system.stateVersion = "24.11";
}
