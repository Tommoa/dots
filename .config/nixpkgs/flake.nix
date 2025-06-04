{
  description = "Tom's nix systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/release-25.05";

    nixpkgs-darwin.url = "github:NixOS/nixpkgs/nixpkgs-25.05-darwin";

    nix-darwin.url = "github:LnL7/nix-darwin/nix-darwin-25.05";
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
