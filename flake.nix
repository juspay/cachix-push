{
  description = "A `flake-parts` module providing an app to push to cachix";
  inputs = {
    devour-flake.url = "github:srid/devour-flake";
    devour-flake.flake = false;
    # https://github.com/cachix/cachix/issues/529
    cachix.url = "github:cachix/cachix/v1.3.3";
  };
  outputs = { self, devour-flake, cachix }: {
    flakeModule = import ./flake-module.nix { inherit devour-flake cachix; };
  };
}
