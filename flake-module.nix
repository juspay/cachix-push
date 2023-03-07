{ self, ... }:

{
  perSystem = { pkgs, lib, config, ... }: {
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
            packages = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              # TODO: Why not push ... all packages by default?
              default = [ "default" ];
              description = ''
                Packages to push to cachix.
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
              cachix
              jq
            ];
            text = ''
              # Push packages
              echo '## Pushing packages: .#${lib.concatStringsSep ", .#" config.cachix-push.packages} ...'
              set -x
              nix "$@" build .#${lib.concatStringsSep " .#" config.cachix-push.packages} --json | \
                jq -r '.[].outputs | to_entries[].value' | \
                cachix push ${config.cachix-push.cacheName}
              set +x
              # Push shell
              echo '## Pushing nix shell ...'
              tmpfile=$(mktemp /tmp/dev-profile.XXXXXX)
              rm "$tmpfile"
              set -x
              nix "$@" develop --profile "$tmpfile" -c echo > /dev/null
              cachix push ${config.cachix-push.cacheName} "$tmpfile"
              set +x
            '';
          });
      };
    };
  };
}

