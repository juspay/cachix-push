{ devour-flake, cachix }:
{ self, ... }:

{
  perSystem = { pkgs, system, lib, config, ... }: {
    options = {
      cachix-push = lib.mkOption {
        type = lib.types.submodule {
          options = {
            cacheName = lib.mkOption {
              type = lib.types.str;
              description = ''
                Name of the cachix cache to push to.
              '';
            };
          };
        };
      };
    };
    config = {
      # A script to push to cachix
      apps.cachix-push = {
        type = "app";
        program = lib.getExe
          (pkgs.writeShellApplication {
            name = "cachix-push";
            runtimeInputs = [
              (pkgs.callPackage devour-flake { inherit devour-flake; })
              cachix.packages.${system}.cachix
            ];
            text = ''
              set -x
              devour-flake . "$@" | cachix push ${config.cachix-push.cacheName}
            '';
          });
      };
    };
  };
}

