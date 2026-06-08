{ lib }:
let
  strip = text:
    let
      lines = lib.splitString "\n" text;
      first = builtins.head lines;
      rest = builtins.tail lines;
    in
    if lib.hasPrefix "#!" first then lib.concatStringsSep "\n" rest else text;

  stripStrict = text:
    let
      lines = lib.splitString "\n" text;
      first = builtins.head lines;
      second = builtins.head (builtins.tail lines);
      rest = builtins.tail (builtins.tail lines);
      afterShebang =
        if second == "set -euo pipefail" then
          lib.concatStringsSep "\n" rest
        else
          lib.concatStringsSep "\n" (builtins.tail lines);
    in
    if lib.hasPrefix "#!" first then afterShebang else text;
in
{
  inherit strip stripStrict;
  readWithout = path: strip (builtins.readFile path);
  readWithoutStrict = path: stripStrict (builtins.readFile path);
  has = text: lib.hasPrefix "#!" text;
  get = text:
    let
      lines = lib.splitString "\n" text;
      first = builtins.head lines;
    in
    if lib.hasPrefix "#!" first then first else null;
}
