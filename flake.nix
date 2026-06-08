{
  description = "Nix library for shebang operations — strip, parse, wrap shell fragments into derivations";

  inputs = {
    nixpkgs-lock.url = "github:pr0d1r2/nixpkgs-lock";
    nixpkgs.follows = "nixpkgs-lock/nixpkgs";
    nix-unit.url = "github:nix-community/nix-unit";
    set-and-setting = {
      url = "github:pr0d1r2/set-and-setting";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-lock,
      nix-unit,
      set-and-setting,
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

      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          # Declarative skill set. Auto-synced into gitignored .claude/ by the
          # default devShell shellHook — no manual sync-set needed.
          agent-set = set-and-setting.lib.mkSet {
            inherit pkgs;
            categories = [
              "opensource"
              "nix"
              "ci"
              "lefthook"
              "git"
              "test"
            ];
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          agentSet = self.packages.${system}.agent-set;
        in
        {
          default = pkgs.mkShell {
            packages = [
              nix-unit.packages.${system}.default
              pkgs.nixfmt
            ];

            # Auto-install skills into gitignored .claude/ on shell entry.
            # agentSet is a pure store path (cached) — this is a copy, not a build.
            # Layout: set.md sits beside set/ so its `@./set/...` imports resolve.
            shellHook = ''
              dst=.claude/skills
              mkdir -p "$dst/set"
              rm -rf "$dst/set/skills" "$dst/set/concepts" "$dst/set.md"
              cp "${agentSet}/set.md" "$dst/set.md"
              cp -r "${agentSet}/skills" "$dst/set/skills"
              cp -r "${agentSet}/concepts" "$dst/set/concepts"
              chmod -R u+w "$dst"
            '';
          };
        }
      );
    };
}
