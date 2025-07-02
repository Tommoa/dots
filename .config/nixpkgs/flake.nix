{
  description = "Tom's nix systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";
    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin.url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = inputs@{ nixpkgs, nix-darwin, home-manager, ... }: {
    homeConfigurations."toma" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "aarch64-darwin";
        config.allowUnfree = true;
        overlays = [
          (import ./overlays)
        ];
      };
      modules = [
        ./home.nix
        {
          home.username = "toma";
          home.homeDirectory = "/Users/toma";
        }
      ];
    };

    homeConfigurations."tommoa" = home-manager.lib.homeManagerConfiguration {
      pkgs = import nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      modules = [
        ./home.nix
        {
          home.username = "tommoa";
          home.homeDirectory = "/home/tommoa";
        }
      ];
    };

    darwinConfigurations."apollo" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [
        ./darwin/configuration.nix
        home-manager.darwinModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.toma = { ... }: {
            imports = [ ./home.nix ];
            home.enableGraphical = true;
          };
        }
      ];
      specialArgs = { inherit inputs; };
    };

    nixosConfigurations."james" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/configuration.nix
        home-manager.nixosModules.home-manager {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.tommoa = { ... }: {
            imports = [ ./home.nix ];
            home.enableGraphical = true;
          };
        }
      ];
      specialArgs = { inherit inputs; name = "james"; };
    };
  };
}
