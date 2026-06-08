# lib output — the unified shebang API. Depends only on nixpkgs.
{ nixpkgs }:
import ../lib { inherit (nixpkgs) lib; }
