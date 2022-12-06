{
  description = "An old (2017) unfinished game project from school";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-21.11";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        dragonvoid = (import ./. ({
          pkgs = pkgs;
        }));
      in
      rec {
        packages.default = dragonvoid;

        apps.main = flake-utils.lib.mkApp {
          drv = dragonvoid;
          exePath = "/bin/dragonvoid";
        };
        apps.arena = flake-utils.lib.mkApp {
          drv = dragonvoid;
          exePath = "/bin/dragonvoid-arena";
        };
        apps.default = apps.main;
      }
    );
}
