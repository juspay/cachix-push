{
  description = "A `flake-parts` module providing an app to push to cachix";
  inputs = {
    flake-outputs.url = "github:srid/flake-outputs";
  };
  outputs = { self, flake-outputs }: {
    flakeModule = import ./flake-module.nix { inherit flake-outputs; };
  };
}
