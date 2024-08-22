{
  description = "A `flake-parts` module providing an app to push and pin to cachix";
  outputs = _: {
    flakeModule = ./flake-module.nix;
  };
}
