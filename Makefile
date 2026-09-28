.DEFAULT_GOAL := help

.PHONY: help darwin-switch darwin-update nixos-switch nixos-update home-switch home-update

help:
	@printf '%s\n' \
	  'make darwin-switch  - activate the macOS configuration' \
	  'make darwin-update  - update inputs and activate macOS' \
	  'make nixos-switch   - activate the NixOS laptop configuration' \
	  'make nixos-update   - update inputs and activate NixOS' \
	  'make home-switch    - activate the standalone Linux Home Manager configuration' \
	  'make home-update    - update inputs and activate standalone Home Manager'

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
