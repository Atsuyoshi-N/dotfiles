{
  description = "Atsuyoshi's dotfiles - nix-darwin + home-manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      mkDarwinSystem = { hostname, username ? "atsuyoshi", hostModule }:
        nix-darwin.lib.darwinSystem {
          system = "aarch64-darwin";
          specialArgs = { inherit self username hostname; };
          modules = [
            home-manager.darwinModules.home-manager
            ./nix/modules/common.nix
            hostModule
          ];
        };
    in
    {
      darwinConfigurations = {
        # Personal Mac
        "AtsuyoshinoMacBook-Pro" = mkDarwinSystem {
          hostname = "AtsuyoshinoMacBook-Pro";
          hostModule = ./nix/hosts/personal.nix;
        };

        # Work Mac (hostname を実際の値に変更してください)
        "WorkMac" = mkDarwinSystem {
          hostname = "WorkMac";
          hostModule = ./nix/hosts/work.nix;
        };
      };
    };
}
