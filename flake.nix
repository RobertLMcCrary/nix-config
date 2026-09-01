{
  description = "My Personal Nix Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
    }:
    let
      username = "robertmccrary";

      # Rename to match `hostnamectl hostname` on the NixOS laptop, and
      # update networking.hostName in modules/nixos.nix to match.
      nixosHostName = "nixos-laptop";

      # Systems to build a standalone (non-NixOS) home-manager config for —
      # e.g. Ubuntu. Add "aarch64-linux" is already covered for ARM boxes.
      standaloneSystems = [
        "x86_64-linux"
        "aarch64-linux"
      ];
    in
    {
      darwinConfigurations."Roberts-MBP" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";

        modules = [
          ./modules/darwin.nix
          home-manager.darwinModules.home-manager
          ({ pkgs, ... }: {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./modules/home/default.nix;
            home-manager.extraSpecialArgs = { };
            users.users.${username} = {
              name = username;
              shell = pkgs.zsh;
              home = "/Users/${username}";
            };
          })
        ];
      };

      # Standalone home-manager configs, for machines where Nix runs
      # without NixOS or nix-darwin managing the whole system (e.g. Ubuntu).
      # Usage: nix run home-manager -- switch --flake .#robertmccrary-x86_64-linux
      homeConfigurations = builtins.listToAttrs (
        map (system: {
          name = "${username}-${system}";
          value = home-manager.lib.homeManagerConfiguration {
            pkgs = import nixpkgs {
              inherit system;
              config.allowUnfree = true;
            };
            modules = [ ./modules/home/default.nix ];
          };
        }) standaloneSystems
      );

      # hosts/nixos/hardware-configuration.nix must exist (generate it on
      # the laptop with `nixos-generate-config --show-hardware-config`) —
      # see hosts/nixos/README.md.
      nixosConfigurations.${nixosHostName} = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux"; # adjust if the laptop is aarch64-linux
        modules = [
          ./hosts/nixos/hardware-configuration.nix
          ./modules/nixos.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.backupFileExtension = "backup";
            home-manager.users.${username} = import ./modules/home/default.nix;
          }
        ];
      };
    };
}
