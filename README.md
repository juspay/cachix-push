# cachix-push

A flake-parts module to push flake outputs to cachix and then pin them.

## Usage

This is a [flake-parts](https://flake.parts/) module that you can import in your `flake.nix` and use:

```nix
{
  imports = [
    inputs.cachix-push.flakeModule
  ];
  perSystem = { self', ... }: {
    cachix-push = {
      cacheName = "mycache";
      pathsToCache = {
        cli = self'.packages.myapp-cli;
        gui = self'.packages.myapp-gui;
        devshell = self'.devShells.default;
      };
    };
  };
}
```

Then, run:

```sh
nix run .#cachix-push
```

### Tips

- If you use Apple silicon, but want to push the Intel binaries to cache, run: `nix run .#cachix-push -- --option system x86_64-darwin`.
