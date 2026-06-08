# Pure nix-unit test set. Run with `nix-unit --flake .#tests`. No shell.
{ nixpkgs }:
let
  inherit (nixpkgs) lib;
in
{
  strip = import ./tests/unit/strip.nix { inherit lib; };
  parse = import ./tests/unit/parse.nix { inherit lib; };
  wrap = import ./tests/unit/wrap.nix { inherit lib; };
}
