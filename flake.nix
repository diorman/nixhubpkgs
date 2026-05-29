{
  description = "Pinned language runtimes. GENERATED from runtimes.json by ./bin/update — edit runtimes.json and re-run, don't hand-edit this file.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    ruby_3_3_10.url = "github:NixOS/nixpkgs/a1bab9e494f5f4939442a57a58d0449a109593fe";
  };

  outputs =
    { self, flake-utils, ... }@inputs:
    let
      # output name -> { input = <flake input name>; attr = <nixpkgs attribute>; }
      runtimes = {
        "ruby-3.3.10" = { input = "ruby_3_3_10"; attr = "ruby"; };
      };
    in
    flake-utils.lib.eachDefaultSystem (system: {
      packages = builtins.mapAttrs (
        _name: spec: inputs.${spec.input}.legacyPackages.${system}.${spec.attr}
      ) runtimes;
    });
}
