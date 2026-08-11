{
  description = "CHANGEME";

  nixConfig = {
    extra-substituters = [ "https://pr0d1r2.cachix.org" ];
    extra-trusted-public-keys = [ "pr0d1r2.cachix.org-1:NfWjbhgAj41byXhCKiaE+av3Vnphm1fTezHXEGsiQIM=" ];
  };

  inputs = {
    nixpkgs-lock.url = "github:pr0d1r2/nixpkgs-lock";
    nixpkgs.follows = "nixpkgs-lock/nixpkgs";

    set-and-setting.url = "github:pr0d1r2/set-and-setting";
    set-and-setting.inputs.nixpkgs-lock.follows = "nixpkgs-lock";
  };

  outputs =
    {
      self,
      nixpkgs,
      set-and-setting,
      ...
    }:
    let
      base = set-and-setting.lib.mkConsumerFlake {
        inherit self nixpkgs set-and-setting;
        fragments = [
          "base"
          "nix"
          "ascii"
          "markdown"
          "yaml"
        ];
        src = ./.;
      };
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
      unitTests =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          cases = nixpkgs.lib.foldl' (all: group: all // group) { }
            (builtins.attrValues (import ./nix/tests.nix { inherit nixpkgs; }));
          failures = nixpkgs.lib.runTests cases;
        in
        pkgs.runCommand "unit-tests" { }
          (if failures == [ ] then
            ''
              echo "nix-unit: ${toString (builtins.length (builtins.attrNames cases))} assertions passed"
              touch "$out"
            ''
          else
            ''
              echo "nix-unit: ${toString (builtins.length failures)} assertion(s) failed:" >&2
              exit 1
            '');
    in
    base
    // {
      tests = import ./nix/tests.nix { inherit nixpkgs; };
      checks = base.checks // nixpkgs.lib.genAttrs systems (system:
        (base.checks.${system} or { }) // {
          unit-tests = unitTests system;
        });
    };
}
