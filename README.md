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

## Examples

- https://github.com/juspay/omnix/pull/340
