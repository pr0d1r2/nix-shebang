# nix-shebang

Pure Nix library for shebang operations — strip, parse, wrap shell fragments
into derivations. See [SPEC.md](SPEC.md) for the full specification.

## Agent skills

Engineering skills (open-source, nix, ci, lefthook, git, test) come from
[set-and-setting](https://github.com/pr0d1r2/set-and-setting). direnv out-links
the `agent-set` derivation into gitignored `.claude/skills/agent` on shell entry
(`use flake` + `nix build .#agent-set --out-link`). The import below resolves
once direnv has run once.

@.claude/skills/agent/set.md
