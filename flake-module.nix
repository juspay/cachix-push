{ self, pkgs, lib, flake-parts-lib, ... }:

let
  inherit (flake-parts-lib)
    mkPerSystemOption;
in
{
  options = {
    perSystem = mkPerSystemOption ({ config, self', pkgs, system, ... }: {
      options = {
        cachix-push = {
          package = lib.mkOption {
            type = lib.types.package;
            description = ''
              The cachix package to use
            '';
            default = pkgs.cachix;
          };
          cacheName = lib.mkOption {
            type = lib.types.str;
            description = ''
              The name of the cachix cache to push to
            '';
          };
          pinPrefix = lib.mkOption {
            type = lib.types.str;
            description = ''
              The prefix to use when pinning paths in the cache

              This is useful when sharing the same cache across multiple projects
            '';
            default = "";
          };
          pathsToCache = lib.mkOption {
            type = lib.types.attrsOf lib.types.path;
            description = ''
              Store paths to push to/pin in a Nix cache (such as cachix)

              When pinning, the path will be pinned as `''${key}-''${system}` in the cache, where `key` is the attrset key.
            '';
          };
        };
      };

      config = {
        apps.cachix-push =
          let
            inherit (config.cachix-push) package pinPrefix pathsToCache cacheName;
          in
          rec {
            inherit (program) meta;
            program = pkgs.writeShellApplication {
              name = "cachix-push-and-pin";
              meta.description = ''
                Run `cachix push` & `cachix pin` for each path in `cache-pins.pathsToCache`
              '';
              runtimeInputs = [ package ];
              text = ''
                set -x
                cachix push ${cacheName} ${lib.concatStringsSep " " (lib.attrValues pathsToCache)}
                ${lib.concatStringsSep "\n" (lib.mapAttrsToList (name: path: ''
                  cachix pin ${cacheName} ${pinPrefix}${name}-${system} ${path}
                '') pathsToCache)}
              '';
            };
          };
      };
    });
  };
}
