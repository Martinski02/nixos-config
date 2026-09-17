{
  description = "NixOS configuration for Martin's systems";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      mkHost = hostName:
        nixpkgs.lib.nixosSystem {
          inherit system;

          specialArgs = {
            inherit inputs hostName;
          };

          modules = [
            ./hosts/${hostName}/default.nix

            home-manager.nixosModules.home-manager

            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;

                extraSpecialArgs = {
                  inherit inputs hostName;
                };

                users.martin = import ./home-manager/martin.nix;
              };
            }
          ];
        };
    in
    {
      nixosConfigurations = {
        martin-pc = mkHost "martin-pc";

        # martin-laptop wird später auf diese Architektur migriert.
      };
    };
}
