# NixOS laptop setup

`flake.nix` imports `hosts/nixos/hardware-configuration.nix` unconditionally,
so it must exist before `nixosConfigurations` will evaluate at all — it's
machine-specific and can't be written from another computer.

On the NixOS laptop:

1. Boot the NixOS installer and install as normal (or, on an existing
   install) run:
   ```
   sudo nixos-generate-config --show-hardware-config > hosts/nixos/hardware-configuration.nix
   ```
   (run from the repo root, or adjust the output path).
2. `git add hosts/nixos/hardware-configuration.nix` — Nix flakes only see
   git-tracked files, so it needs to at least be staged before `nix`/
   `nixos-rebuild` commands can see it, even before committing.
3. In `flake.nix`, set `nixosHostName` to match this machine's real
   hostname (also update `networking.hostName` in `modules/nixos.nix`).
4. Adjust `system = "x86_64-linux"` in `flake.nix` if the laptop is
   aarch64.
5. Run:
   ```
   sudo nixos-rebuild switch --flake .#<hostname>
   ```
