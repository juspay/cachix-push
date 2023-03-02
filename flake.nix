{
  description = "A `flake-parts` module providing an app to push to cachix";
  outputs = { self, ... }: {
    flakeModule = ./flake-module.nix;
  };
}
