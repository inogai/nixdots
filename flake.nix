{
  description = "Home Manager configuration of inogai";

  nixConfig = {
    extra-substituters = [
      "https://inogai.cachix.org"
      "https://numtide.cachix.org"
    ];
    extra-trusted-public-keys = [
      "inogai.cachix.org-1:gJVZ8+i50F4/I9/TBnkpBlAGzqzpJQdtK/iQATuWY60="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
    ];
  };

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nvim-inogai = {
      url = "github:inogai/nvim-inogai";
      # url = "git+file:///Users/inogai/flakes/nvim-inogai/";
      # inputs.nixpkgs.follows = "nixpkgs";
    };
    sbar-inogai = {
      url = "github:inogai/sbar-inogai";
      # url = "git+file:///Users/inogai/flakes/sbar-inogai/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-yazi-flavors = {
      url = "github:aguirre-matteo/nix-yazi-flavors";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    tuios = {
      url = "github:Gaurav-Gosain/tuios";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-ai-tools.url = "github:numtide/nix-ai-tools";
    nix-colors.url = "github:misterio77/nix-colors";
    hm-ricing-mode.url = "github:mipmip/hm-ricing-mode";
  };

  outputs = {
    nixpkgs,
    home-manager,
    hm-ricing-mode,
    nur,
    nvim-inogai,
    sbar-inogai,
    nix-yazi-flavors,
    nix-ai-tools,
    nix-colors,
    tuios,
    ...
  }: let
    system = "aarch64-darwin";
    overlay = final: prev:
      (nur.overlays.default final prev)
      // (nix-yazi-flavors.overlays.default final prev)
      // {
        nvim-inogai = nvim-inogai.outputs.packages.${final.system}.nvim-inogai;
        sbar-inogai = sbar-inogai.outputs.packages.${final.system}.sbar-inogai;
        nix-ai-tools = nix-ai-tools.outputs.packages.${final.system};
        tuios = {
          tuios = tuios.outputs.packages.${final.system}.tuios;
        };
      };
    pkgs = nixpkgs.legacyPackages.${system}.extend overlay;
  in {
    homeConfigurations."inogai" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      # Specify your home configuration modules here, for example,
      # the path to your home.nix.
      modules = [./home.nix hm-ricing-mode.homeManagerModules.hm-ricing-mode];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
      extraSpecialArgs = {
        inherit nix-colors;
      };
    };
  };
}
