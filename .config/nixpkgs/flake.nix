{
  description = "Tom's nix systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-24.11";

    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-24.11-darwin";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs-darwin";
  };

  outputs = inputs@{ nix-darwin, ... }: {
    darwinConfigurations."apollo" = nix-darwin.lib.darwinSystem {
      system = "aarch64-darwin";
      modules = [ ./darwin/configuration.nix ];
      specialArgs = { inherit inputs; };
    };
  };
}
