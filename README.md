# cachix-push

A flake app that can push all buildable flake outputs (determined via [devour-flake](https://github.com/srid/devour-flake)) to cachix.

## Usage

This is a [flake-parts](https://flake.parts/) module that you can import in your `flake.nix` and use:

```nix
{
  imports = [
    inputs.cachix-push.flakeModule
  ];
  perSystem = { ... }: {
    cachix-push = {
      cacheName = "mycache";
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
