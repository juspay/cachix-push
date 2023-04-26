{
  description = "A `flake-parts` module providing an app to push to cachix";
  inputs = {
    devour-flake.url = "github:srid/devour-flake";
    devour-flake.flake = false;
  };
  outputs = { self, devour-flake }: {
    flakeModule = import ./flake-module.nix { inherit devour-flake; };
  };
}
