# nixhubpkgs

Pinned language runtimes exposed as flake outputs — a small, self-maintained
stand-in for Nixhub/devbox, for projects that use [devenv](https://devenv.sh)
or plain Nix.

Each runtime is pinned to a specific **nixpkgs commit** (resolved via
[Nixhub](https://www.nixhub.io) / the devbox search service) so you get the
exact patch version with the prebuilt binary from `cache.nixos.org` — no
source builds, no overlay.

## How it works

- **`packages.json`** — the source of truth you edit: `package -> [versions]`.
- **`./bin/update`** — resolves each version to a nixpkgs commit + attr, then…
- **generates `flake.nix`** — one real flake **input** per runtime
  (`<pkg>_<ver>.url = github:NixOS/nixpkgs/<commit>`) and `flake.lock` pins them.

`flake.nix` is a **generated artifact** — don't hand-edit it; edit `packages.json`
and re-run `./bin/update`. Using real flake inputs (rather than `fetchTarball`)
keeps things lazy-trees friendly and pins revisions in `flake.lock`.

## Outputs

`packages.<system>."<package>-<version>"`, e.g. `packages.aarch64-darwin."ruby-3.3.10"`.

## Usage (devenv)

```yaml
# devenv.yaml
inputs:
  runtimes:
    url: github:diorman/nixhubpkgs
```

```nix
# devenv.nix
languages.ruby = {
  enable = true;
  package = inputs.runtimes.packages.${pkgs.system}."ruby-3.3.10";
};
```

## Usage (plain nix)

```sh
nix shell github:diorman/nixhubpkgs#"ruby-3.3.10"
```

## Adding / bumping a version

1. Edit `packages.json` (add a package or a version string).
2. Run `./bin/update` (needs `curl`, `jq`, `nix`) — regenerates `flake.nix` + `flake.lock`.
3. Commit `packages.json`, `flake.nix`, and `flake.lock`.
