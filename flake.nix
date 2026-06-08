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
      nixpkgs,
      nix-unit,
      set-and-setting,
      ...
    }:
    let
      forAllSystems = nixpkgs.lib.genAttrs (import ./nix/systems.nix);

      perSystem =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          agentSet = import ./nix/agent-set.nix { inherit pkgs set-and-setting; };
        in
        {
          packages = {
            agent-set = agentSet;
          };
          devShells = import ./nix/devshells.nix {
            inherit pkgs;
            nix-unit = nix-unit.packages.${system}.default;
          };
        };
    in
    {
      lib = import ./nix/lib.nix { inherit nixpkgs; };
      tests = import ./nix/tests.nix { inherit nixpkgs; };

      packages = forAllSystems (system: (perSystem system).packages);
      devShells = forAllSystems (system: (perSystem system).devShells);
    };
}
