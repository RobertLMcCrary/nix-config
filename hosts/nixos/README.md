# NixOS laptop setup

This flake's `nixosConfigurations` output only appears once
`hosts/nixos/hardware-configuration.nix` exists (see the
`builtins.pathExists` guard in `flake.nix`), because that file is
machine-specific and can't be written from another computer.

On the NixOS laptop:

1. Boot the NixOS installer and install as normal (or, on an existing
   install) run:
   ```
   nixos-generate-config --show-hardware-config > hardware-configuration.nix
   ```
2. Copy the generated `hardware-configuration.nix` into this directory.
3. In `flake.nix`, set `nixosHostName` to match this machine's real
   hostname (also update `networking.hostName` in `modules/nixos.nix`).
4. Adjust `system = "x86_64-linux"` in `flake.nix` if the laptop is
   aarch64.
5. Clone this repo onto the laptop and run:
   ```
   sudo nixos-rebuild switch --flake .#<hostname>
   ```
