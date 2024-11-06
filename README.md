# cachix-push

A flake app to **push and pin** multiple store paths [built by Omnix](https://omnix.page/om/ci.html) to cachix. Better than `nix build ... | cachix push ...`.

When you pin paths, they are indexed by `system` and custom `prefix` (usually git branch). In CI, you can do this only from say `main` branch, thus having up-to-date cache for your primary branch and have it pinned.

## Usage

Push and pin all store paths built by [`om ci`](https://omnix.page/om/ci.html).

```sh
# First, build the flake.
om ci run --results=om.json

# Push to https://mycache.cachix.org
nix run github:juspay/cachix-push -- --cache mycache --subflake ROOT --prefix "$(git branch --show-current)" < om.json
```

This will output at the end what got pinned, for example:

```text
[..]
Pinning on https://om.cachix.org
Pin cachix-push-om-x86_64-linux-rust-flake-devshell => /nix/store/wcj64d5yv56bd728737rczxkdjwvfibs-rust-flake-devshell
Pin cachix-push-om-x86_64-linux-treefmt-check => /nix/store/7rpn41zxc5yflp2za3ag80dxdmcwdx99-treefmt-check
Pin cachix-push-om-x86_64-linux-omnix-cli => /nix/store/ci6vsd9wpd8h3mrjxf7ny4mk1ncjjprc-omnix-cli-0.1.0
Pin cachix-push-om-x86_64-linux-omnix-devshell => /nix/store/n4ri7biinnpwx0d5s68vgni6wjlichn1-omnix-devshell
```

which gets reflected in the cachix UI as:

![image](https://github.com/user-attachments/assets/926c8c18-43fc-4d7a-af61-4c939c494a55)

## Examples

- https://github.com/juspay/omnix/pull/340
