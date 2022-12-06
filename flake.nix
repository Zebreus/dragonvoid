{
  # The flake identifier.
  name = "dragonvoid";

  # The epoch may be used in the future to determine how Nix
  # expressions inside this flake are to be parsed.
  epoch = 2022;

  # Some other metadata.
  description = "An old (2017) unfinished game project from school";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let pkgs = nixpkgs.legacyPackages.${system}; in
      rec {
        packages = flake-utils.lib.flattenTree {
          hello = pkgs.hello;
          gitAndTools = pkgs.gitAndTools;
        };
        defaultPackage = packages.hello;
        apps.hello = flake-utils.lib.mkApp { drv = packages.hello; };
        defaultApp = apps.hello;
      }
    );
}
