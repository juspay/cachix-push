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