# Contributing

Thanks for your interest in nix-shebang.

## Setup

```bash
nix develop          # dev shell: nix-unit, nixfmt, lint hooks
```

direnv users get the same on entry via `direnv allow`.

## Testing

```bash
nix-unit --flake .#tests   # run the unit tests
nix flake check            # evaluate all flake outputs
```

Every `nix/lib/*.nix` has a matching `nix/tests/unit/*.nix` (1-to-1
coverage). Add or update tests with any change.

## Style

- Nix is formatted with `nixfmt`.
- Lefthook pre-commit / pre-push hooks enforce formatting and lint --
  stay in the `nix develop` shell so they run.

## Commits

Conventional Commits (`feat:`, `fix:`, `chore:`, `refactor:`, ...) with a
subject of 50 characters or fewer.

## License

By contributing you agree your work is licensed under the MIT terms in
[LICENSE](LICENSE).
