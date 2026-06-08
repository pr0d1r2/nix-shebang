# devShells output. Tooling for tests, formatting, and lint hooks.
{ pkgs, nix-unit }:
{
  default = pkgs.mkShell {
    packages = [
      nix-unit
      pkgs.nixfmt
      pkgs.lefthook
      pkgs.statix
      pkgs.deadnix
      pkgs.shellcheck
    ];

    # Install git hooks on first shell entry (idempotent).
    shellHook = ''
      [ -f .git/hooks/pre-commit ] || lefthook install
    '';
  };
}
