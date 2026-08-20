{
  description = "Pinned language runtimes. GENERATED from pkgs.json by ./bin/update — edit pkgs.json and re-run, don't hand-edit this file.";

  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nodejs_24_12_0.url = "github:NixOS/nixpkgs/3edc4a30ed3903fdf6f90c837f961fa6b49582d1";
    ruby_3_3_10.url = "github:NixOS/nixpkgs/a1bab9e494f5f4939442a57a58d0449a109593fe";
    ruby_3_3_7.url = "github:NixOS/nixpkgs/ebe4301cbd8f81c4f8d3244b3632338bbeb6d49c";
    temurin_bin_17_17_0_11.url = "github:NixOS/nixpkgs/b60793b86201040d9dee019a05089a9150d08b5b";
    terraform_1_9_8.url = "github:NixOS/nixpkgs/34a626458d686f1b58139620a8b2793e9e123bba";
    nixpkgs_overrides.url = "github:NixOS/nixpkgs/afe3d8ac4395617bdcdac9f188ac8717a062e014";
  };

  outputs =
    { self, flake-utils, ... }@inputs:
    let
      # output name -> { input = <flake input name>; attr = <nixpkgs attribute>; }
      runtimes = {
        "nodejs-24.12.0" = { input = "nodejs_24_12_0"; attr = "nodejs_24"; };
        "ruby-3.3.10" = { input = "ruby_3_3_10"; attr = "ruby"; };
        "ruby-3.3.7" = { input = "ruby_3_3_7"; attr = "ruby"; };
        "temurin-bin-17-17.0.11" = { input = "temurin_bin_17_17_0_11"; attr = "temurin-bin-17"; };
        "terraform-1.9.8" = { input = "terraform_1_9_8"; attr = "terraform"; };
      };
    in
    flake-utils.lib.eachDefaultSystem (system: {
      packages = builtins.mapAttrs (
        _name: spec: inputs.${spec.input}.legacyPackages.${system}.${spec.attr}
      ) runtimes // (import ./overrides.nix { inherit inputs system; });
    });
}
