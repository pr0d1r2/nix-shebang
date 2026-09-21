# LLM-Generated Code Disclaimer

<!-- hallucinogen:tending-disclaimer start -->
**Also tended by an autonomous loop.** This repository is now maintained by an
autonomous loop that opens pull requests, drives them to green CI, and merges
them without a human reading the diff. The merge gate is this repository's own
checks plus an automated review, not human approval.

Some classes of change are held for a human by design: releases, anything
touching the loop's own safety rails, and anything that could publish to a
package registry. Everything else is not.

Both disclosures apply. The text below records how this codebase was originally
written with LLM assistance; any statement in it about human review describes
that period, not the autonomous tending that followed.

---
<!-- hallucinogen:tending-disclaimer end -->

This project contains code that was generated, reviewed, and validated by Large Language Models (LLMs) as part of the development process.

## Scope

Per constraint C8 in [SPEC.md](../SPEC.md), this codebase is "LLM-generated, validated via CI". The following components were created with LLM assistance:

- Core library functions in `nix/lib/*.nix`
- Unit tests in `nix/tests/unit/*.nix`
- Test vectors in `nix/tests/vectors.nix`

## Validation

All LLM-generated code is validated through:

- Automated CI pipeline on three platforms (x86_64-linux, aarch64-linux, aarch64-darwin)
- Unit test coverage (1-to-1 ratio per constraint C4)
- Human code review and manual testing
- Functional verification against the project specification

## Code Quality

The use of LLM assistance does not diminish the quality or reliability guarantees:

- All functionality is covered by automated tests
- Results are cached and reproducible via Nix
- The library maintains pure Nix semantics without external dependencies
- Output is validated against published test vectors

## Licensing

This project is licensed under the MIT License (see [LICENSE](../LICENSE)). LLM-generated code is subject to the same license terms as hand-written code within this repository.

## Reproduction

Users can verify the behavior of all library functions by:

```bash
nix eval --json github:pr0d1r2/nix-shebang#vectors
```

This exports shared test vectors that define expected behavior, which can be used to validate ports in other languages or alternative implementations.
