# cachix-push

A flake app to **push and pin** multiple store paths [built by Omnix](https://omnix.page/om/ci.html) to cachix. Better than `nix build ... | cachix push ...`.

When you pin paths, they are indexed by `system` and custom `prefix` (usually git branch). In CI, you can do this only from say `main` branch, thus having up-to-date cache for your primary branch and have it pinned.

## Usage

Push and pin all store paths built by [`om ci`](https://omnix.page/om/ci.html). First, run `om ci` to build outputs:

```sh
# First, build the flake.
om ci run --results=om.json
```

This will create a JSON like:

```json
{
  "systems": [
    "x86_64-linux"
  ],
  "result": {
    "omnix": {
      "build": {
        "byName": {
          "treefmt-check": "/nix/store/x14rcm3djs4cr9d2ih0msxw8jiwdm1yn-treefmt-check",
          "omnix-cli": "/nix/store/ci6vsd9wpd8h3mrjxf7ny4mk1ncjjprc-omnix-cli-0.1.0",
          "omnix-devshell": "/nix/store/n4ri7biinnpwx0d5s68vgni6wjlichn1-omnix-devshell",
          "rust-flake-devshell": "/nix/store/wcj64d5yv56bd728737rczxkdjwvfibs-rust-flake-devshell"
        }
      }
    },
  }
} 
```

(Everything under `byName` represents the store paths of flake output indexed by their derivation name)

Which can you pass to this program to push & pin on cache:

```sh
# Push to https://mycache.cachix.org
nix run github:juspay/cachix-push -- --cache mycache --subflake ROOT --prefix "$(git branch --show-current)" < om.json
```

This will output at the end what got pinned, for example:

```text
[..]
Pinning on https://om.cachix.org
Pin main-x86_64-linux-treefmt-check => /nix/store/x14rcm3djs4cr9d2ih0msxw8jiwdm1yn-treefmt-check
Pin main-x86_64-linux-omnix-cli => /nix/store/ci6vsd9wpd8h3mrjxf7ny4mk1ncjjprc-omnix-cli-0.1.0
Pin main-x86_64-linux-omnix-devshell => /nix/store/n4ri7biinnpwx0d5s68vgni6wjlichn1-omnix-devshell
Pin main-x86_64-linux-rust-flake-devshell => /nix/store/wcj64d5yv56bd728737rczxkdjwvfibs-rust-flake-devshell
```

which gets reflected in the cachix UI as:

![image](https://github.com/user-attachments/assets/1e392d69-7f22-4c38-946b-e0725d69b1fb)

## GitHub workflow example

- https://github.com/juspay/omnix/pull/340
