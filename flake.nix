{
  description = "Home Manager configuration of inogai";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur-packages = {
      url = "github:inogai/nur-packages";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-yazi-flavors = {
      url = "github:aguirre-matteo/nix-yazi-flavors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, home-manager, nur-packages, nix-yazi-flavors, ... }:
    let
      system = "aarch64-darwin";
      overlay = final: prev: (nix-yazi-flavors.overlays.default final prev) // {
        inogai = nur-packages.packages.${final.system};
      };
      pkgs = nixpkgs.legacyPackages.${system}.extend overlay;
    in
    {
      homeConfigurations."inogai" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = { };
      };
    };
}
