{ lib }:
let
  wrap = import ../../../lib/wrap.nix { inherit lib; };
in
{
  testToShellScriptIsFunction = {
    expr = builtins.isFunction wrap.toShellScript;
    expected = true;
  };

  testToShellApplicationIsFunction = {
    expr = builtins.isFunction wrap.toShellApplication;
    expected = true;
  };

  testToTextFileIsFunction = {
    expr = builtins.isFunction wrap.toTextFile;
    expected = true;
  };
}
