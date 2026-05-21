.PHONY: switch update

switch:
	sudo darwin-rebuild switch --flake .#Roberts-MBP

update:
	nix flake update
	sudo darwin-rebuild switch --flake .#Roberts-MBP
