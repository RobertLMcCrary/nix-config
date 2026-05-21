{
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

  outputs = { self, nixpkgs, nix-darwin, home-manager }: {
    darwinConfigurations."Roberts-MBP" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";

      modules = [
        ./modules/darwin.nix
        home-manager.darwinModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.backupFileExtension = "backup";
          home-manager.users.robertmccrary = import ./modules/home.nix;
          home-manager.extraSpecialArgs = { };
          # tell darwin the user exists
          users.users.robertmccrary = {
            name = "robertmccrary";
            home = "/Users/robertmccrary";
          };
        }
      ];
    };
  };
}
