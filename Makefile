.PHONY: switch update nixos-switch nixos-update home-switch home-update

# macOS (nix-darwin)
darwin-switch:
	sudo darwin-rebuild switch --flake .#Roberts-MBP

darwin-update:
	nix flake update
	sudo darwin-rebuild switch --flake .#Roberts-MBP

# NixOS laptop
nixos-switch:
	sudo nixos-rebuild switch --flake .#nixos-laptop

nixos-update:
	nix flake update
	sudo nixos-rebuild switch --flake .#nixos-laptop

# Any other Linux (e.g. Ubuntu) with Nix installed
home-switch:
	nix run home-manager -- switch --flake .#robertmccrary-x86_64-linux

home-update:
	nix flake update
	nix run home-manager -- switch --flake .#robertmccrary-x86_64-linux
