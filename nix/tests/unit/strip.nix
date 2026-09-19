{ lib }:
let
  strip = import ../../lib/strip.nix { inherit lib; };
  # One test per shared vector per function (tests/vectors.nix).
  vectorTests = builtins.listToAttrs (
    lib.concatMap (
      v:
      map
        (fn: {
          name = "testVector_${v.name}_${fn}";
          value = {
            expr = strip.${fn} v.input;
            expected = v.${fn};
          };
        })
        [
          "has"
          "get"
          "strip"
          "stripStrict"
        ]
    ) (import ../vectors.nix)
  );
in
vectorTests
// {
  testStripRemovesBashShebang = {
    expr = strip.strip "#!/usr/bin/env bash\necho hello\n";
    expected = "echo hello\n";
  };

  testStripRemovesShShebang = {
    expr = strip.strip "#!/bin/sh\necho hello";
    expected = "echo hello";
  };

  testStripRemovesPythonShebang = {
    expr = strip.strip "#!/usr/bin/env python3\nprint('hi')";
    expected = "print('hi')";
  };

  testStripPreservesTextWithoutShebang = {
    expr = strip.strip "echo hello";
    expected = "echo hello";
  };

  testStripPreservesTrailingNewline = {
    expr = strip.strip "#!/usr/bin/env bash\necho hello\n";
    expected = "echo hello\n";
  };

  testStripPreservesMultilineContent = {
    expr = strip.strip "#!/usr/bin/env bash\nset -euo pipefail\necho hello\n";
    expected = "set -euo pipefail\necho hello\n";
  };

  testStripStrictRemovesShebangAndSetFlags = {
    expr = strip.stripStrict "#!/usr/bin/env bash\nset -euo pipefail\necho hello\n";
    expected = "echo hello\n";
  };

  testStripStrictOnlyRemovesShebangWhenNoSetFlags = {
    expr = strip.stripStrict "#!/usr/bin/env bash\necho hello\n";
    expected = "echo hello\n";
  };

  testStripStrictHandlesSingleLineShebang = {
    expr = strip.stripStrict "#!/bin/bash";
    expected = "";
  };

  testStripStrictPreservesTextWithoutShebang = {
    expr = strip.stripStrict "echo hello";
    expected = "echo hello";
  };

  testHasReturnsTrueForShebangText = {
    expr = strip.has "#!/usr/bin/env bash\necho hello";
    expected = true;
  };

  testHasReturnsFalseForNonShebangText = {
    expr = strip.has "echo hello";
    expected = false;
  };

  testGetReturnsShebangLine = {
    expr = strip.get "#!/usr/bin/env bash\necho hello";
    expected = "#!/usr/bin/env bash";
  };

  testGetReturnsNullForNonShebangText = {
    expr = strip.get "echo hello";
    expected = null;
  };
}
