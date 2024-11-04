{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";
    pog.url = "github:jpetrucciani/pog";
    pog.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems = [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      perSystem = { pkgs, system, ... }: {
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [ inputs.pog.overlays.${system}.default ];
        };
        packages.default = pkgs.callPackage ./default.nix { };

        devShells.default = pkgs.mkShell {
          packages = [
            pkgs.nixd # Nix language server
          ];
        };
      };
    };
}
