{ lib }:
let
  parse = import ../../lib/parse.nix { inherit lib; };
  # One test per shared vector per function (tests/vectors.nix).
  vectorTests = builtins.listToAttrs (
    lib.concatMap (
      v:
      map
        (fn: {
          name = "testVector_${v.name}_${fn}";
          value = {
            expr = parse.${fn} v.input;
            expected = v.${fn};
          };
        })
        [
          "parse"
          "isBash"
          "isSh"
          "isShellScript"
        ]
    ) (import ../vectors.nix)
  );
in
vectorTests
// {
  testParseExtractsEnvBashShebang = {
    expr = parse.parse "#!/usr/bin/env bash\necho hello";
    expected = {
      interpreter = "/usr/bin/env";
      args = [ "bash" ];
      isEnv = true;
      resolvedInterpreter = "bash";
    };
  };

  testParseIgnoresRepeatedSpaces = {
    expr = parse.parse "#!/usr/bin/env  bash\necho hello";
    expected = {
      interpreter = "/usr/bin/env";
      args = [ "bash" ];
      isEnv = true;
      resolvedInterpreter = "bash";
    };
  };

  testParseExtractsDirectBashShebang = {
    expr = parse.parse "#!/bin/bash\necho hello";
    expected = {
      interpreter = "/bin/bash";
      args = [ ];
      isEnv = false;
      resolvedInterpreter = "/bin/bash";
    };
  };

  testParseExtractsPythonShebang = {
    expr = parse.parse "#!/usr/bin/env python3\nprint('hi')";
    expected = {
      interpreter = "/usr/bin/env";
      args = [ "python3" ];
      isEnv = true;
      resolvedInterpreter = "python3";
    };
  };

  testParseReturnsNullForNonShebang = {
    expr = parse.parse "echo hello";
    expected = null;
  };

  testIsBashTrueForEnvBash = {
    expr = parse.isBash "#!/usr/bin/env bash\necho hello";
    expected = true;
  };

  testIsBashTrueForDirectBash = {
    expr = parse.isBash "#!/bin/bash\necho hello";
    expected = true;
  };

  testIsBashFalseForSh = {
    expr = parse.isBash "#!/bin/sh\necho hello";
    expected = false;
  };

  testIsBashFalseForPython = {
    expr = parse.isBash "#!/usr/bin/env python3\nprint('hi')";
    expected = false;
  };

  testIsShTrueForEnvSh = {
    expr = parse.isSh "#!/usr/bin/env sh\necho hello";
    expected = true;
  };

  testIsShTrueForBinSh = {
    expr = parse.isSh "#!/bin/sh\necho hello";
    expected = true;
  };

  testIsShTrueForUsrBinSh = {
    expr = parse.isSh "#!/usr/bin/sh\necho hello";
    expected = true;
  };

  testIsShFalseForBash = {
    expr = parse.isSh "#!/usr/bin/env bash\necho hello";
    expected = false;
  };

  testIsShellScriptTrueForBash = {
    expr = parse.isShellScript "#!/usr/bin/env bash\necho hello";
    expected = true;
  };

  testIsShellScriptTrueForSh = {
    expr = parse.isShellScript "#!/bin/sh\necho hello";
    expected = true;
  };

  testIsShellScriptTrueForEnvSh = {
    expr = parse.isShellScript "#!/usr/bin/env sh\necho hello";
    expected = true;
  };

  testIsShellScriptTrueForUsrBinSh = {
    expr = parse.isShellScript "#!/usr/bin/sh\necho hello";
    expected = true;
  };

  testIsShellScriptFalseForPython = {
    expr = parse.isShellScript "#!/usr/bin/env python3\nprint('hi')";
    expected = false;
  };
}
