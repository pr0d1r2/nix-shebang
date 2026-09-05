{
  self,
  nixpkgs,
  set-and-setting,
}:

let
  supportedSystems = [
    "aarch64-darwin"
    "x86_64-darwin"
    "x86_64-linux"
    "aarch64-linux"
  ];
  forAllSystems =
    f: nixpkgs.lib.genAttrs supportedSystems (system: f nixpkgs.legacyPackages.${system});

  fragments = [
    "base"
    "nix"
    "ascii"
    "markdown"
    "yaml"
  ];

  # The set-and-setting consumer standard: packages, devShells, apps and the
  # guardrail checks. Everything below is merged over it, so `checks` keeps
  # the standard's entries and gains this repo's `unit-tests`.
  standard = set-and-setting.lib.mkConsumerFlake {
    inherit
      self
      nixpkgs
      set-and-setting
      fragments
      ;
    src = ../.;
  };

  tests = import ./tests.nix { inherit nixpkgs; };
in
nixpkgs.lib.recursiveUpdate standard {
  # Consumer-facing API: `nix-shebang.lib.{strip,parse,wrap,...}`
  # (README / SPEC I.lib / ATTRIBUTION). System-independent -- pure lib.
  lib = import ./lib { inherit (nixpkgs) lib; };

  # nix-unit test set: `nix-unit --flake .#tests` (see nix/tests.nix).
  inherit tests;

  checks = forAllSystems (pkgs: {
    # nix-unit assertion set as a `nix flake check` derivation (SPEC C3 /
    # I.checks). Merges every `nix/tests/unit/*.nix` group into one flat
    # set and runs `lib.runTests`, so a regression in strip/parse/wrap
    # fails CI. New lib+test pairs are picked up automatically.
    unit-tests =
      let
        cases = nixpkgs.lib.foldl' (a: b: a // b) { } (builtins.attrValues tests);
        failures = nixpkgs.lib.runTests cases;
      in
      pkgs.runCommand "unit-tests" { } (
        if failures == [ ] then
          ''
            echo "nix-unit: ${toString (builtins.length (builtins.attrNames cases))} assertions passed"
            touch "$out"
          ''
        else
          ''
            echo "nix-unit: ${toString (builtins.length failures)} assertion(s) failed:" >&2
            ${nixpkgs.lib.concatMapStringsSep "\n" (
              f: "echo ${nixpkgs.lib.escapeShellArg "  - ${f.name}"} >&2"
            ) failures}
            exit 1
          ''
      );
  });
}
