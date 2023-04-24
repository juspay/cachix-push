{
  description = "A `flake-parts` module providing an app to push to cachix";
  inputs = {
    flake-outputs.url = "github:srid/flake-outputs";
    # https://github.com/cachix/cachix/issues/529
    cachix.url = "github:cachix/cachix/v1.3.3";
  };
  outputs = { self, flake-outputs, cachix }: {
    flakeModule = import ./flake-module.nix { inherit flake-outputs cachix; };
  };
}
