{
  description = "Nix library for shebang operations — strip, parse, wrap shell fragments into derivations";

  inputs = {
    nixpkgs-lock.url = "github:pr0d1r2/nixpkgs-lock";
    nixpkgs.follows = "nixpkgs-lock/nixpkgs";
    nix-unit.url = "github:nix-community/nix-unit";
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-lock,
      nix-unit,
    }:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];

      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      lib = import ./lib { inherit (nixpkgs) lib; };

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          nix-unit-pkg = nix-unit.packages.${system}.default;
        in
        {
          unit = pkgs.runCommand "nix-shebang-tests" { nativeBuildInputs = [ nix-unit-pkg ]; } ''
            export HOME="$(mktemp -d)"
            nix-unit --expr 'import ${self}/tests/unit/strip.nix { lib = (builtins.getFlake "${self}").inputs.nixpkgs.lib; }'
            nix-unit --expr 'import ${self}/tests/unit/parse.nix { lib = (builtins.getFlake "${self}").inputs.nixpkgs.lib; }'
            nix-unit --expr 'import ${self}/tests/unit/wrap.nix { lib = (builtins.getFlake "${self}").inputs.nixpkgs.lib; }'
            touch $out
          '';
        }
      );

      tests = forAllSystems (
        system:
        let
          inherit (nixpkgs) lib;
        in
        {
          strip = import ./tests/unit/strip.nix { inherit lib; };
          parse = import ./tests/unit/parse.nix { inherit lib; };
          wrap = import ./tests/unit/wrap.nix { inherit lib; };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            packages = [
              nix-unit.packages.${system}.default
              pkgs.nixfmt
            ];
          };
        }
      );
    };
}
