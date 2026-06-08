# devShells output. Lefthook wrapper binaries come from set-and-setting's ci
# shell (inputsFrom) -- the same source the remote lefthook.yml expects. Local
# extras: nix-unit (test runner, no remote) + nixfmt (manual formatting).
{
  pkgs,
  nix-unit,
  lefthookShell,
}:
{
  default = pkgs.mkShell {
    inputsFrom = [ lefthookShell ];

    packages = [
      nix-unit
      pkgs.nixfmt
    ];

    # Install git hooks on first shell entry (idempotent).
    shellHook = ''
      [ -f .git/hooks/pre-commit ] || lefthook install
    '';
  };
}
