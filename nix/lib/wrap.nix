{ lib }:
let
  stripFns = import ./strip.nix { inherit lib; };
in
{
  toShellScript =
    {
      pkgs,
      name,
      src,
    }:
    pkgs.writeShellScriptBin name (stripFns.readWithout src);

  toShellApplication =
    {
      pkgs,
      name,
      src,
      meta ? { },
    }:
    pkgs.writeShellApplication {
      inherit name meta;
      text = stripFns.readWithoutStrict src;
    };

  toTextFile =
    {
      pkgs,
      name,
      src,
    }:
    pkgs.writeTextFile {
      inherit name;
      destination = "/bin/${name}";
      executable = true;
      text = builtins.readFile src;
    };
}
