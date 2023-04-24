{ flake-outputs, cachix }:
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
            runtimeInputs = with pkgs; [
              nix
              jq
              flake-outputs.packages.${system}.default
              cachix.packages.${system}.cachix
            ];
            text = ''
              OUTPUTS=$(flake-outputs)
              echo "Flake outputs to push:"
              echo "$OUTPUTS"
              set -x
              for DRV in $OUTPUTS
              do
                nix build --no-link --no-update-lock-file --print-out-paths ".#$DRV" | cachix push ${config.cachix-push.cacheName}
              done
            '';
          });
      };
    };
  };
}

