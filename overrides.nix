# Hand-maintained source-built overrides for versions not yet available via
# pkgs.json / Nixhub. These BUILD FROM SOURCE (no cache.nixos.org binary).
# ./bin/update merges these into the flake's packages. Remove an entry here AND
# its input in overrides.json once the version lands in nixpkgs and can be added
# the normal way through pkgs.json.
{ inputs, system }:
let
  base = inputs.nixpkgs_overrides;
  pkgs = base.legacyPackages.${system};
  # ruby's `passthru.version` is a structured object (with .major/.libDir/etc.),
  # NOT a plain string — code like ruby-modules does `ruby.version.major`. Rebuild
  # a proper 3.4.10 object with nixpkgs' own helper instead of a bare string.
  mkRubyVersion = import "${base}/pkgs/development/interpreters/ruby/ruby-version.nix" {
    inherit (pkgs) lib;
  };
in
{
  # ruby 3.4.10 is released upstream but not yet in nixpkgs (ruby_3_4 = 3.4.9),
  # so it can't be pinned to a prebuilt binary. Build it from source by bumping
  # the version + tarball on the 3.4.9 derivation.
  "ruby-3.4.10" = pkgs.ruby_3_4.overrideAttrs (old: rec {
    version = "3.4.10";
    src = pkgs.fetchurl {
      url = "https://cache.ruby-lang.org/pub/ruby/3.4/ruby-${version}.tar.gz";
      hash = "sha256-7O4tByoU8tFDR91W39j+XDEwq/URe/qsvaD075zEKew=";
    };
    # Keep the structured passthru.version in sync so consumers see 3.4.10.
    passthru = (old.passthru or { }) // { version = mkRubyVersion "3" "4" "10" ""; };
  });
}
