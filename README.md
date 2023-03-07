# cachix-push

A flake app that can push packages and devshells to cachix

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
      packages = [ "default" ];
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

## But why?

While pushing to a Nix cache is best done automatically by CI, there are situations where you want to manually do this. Notably, Github Actions CI [doesn't support ARM macOS yet](https://github.com/actions/runner-images/issues/2187) - so to provide a macOS cache to your team, you need to manually push to cachix (or use a different CI service).
