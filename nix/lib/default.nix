{ lib }:
let
  strip = import ./strip.nix { inherit lib; };
  parse = import ./parse.nix { inherit lib; };
  wrap = import ./wrap.nix { inherit lib; };
in
strip // parse // wrap
