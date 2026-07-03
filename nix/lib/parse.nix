{ lib }:
let
  parseShebang =
    line:
    let
      withoutPrefix = lib.removePrefix "#!" line;
      parts = lib.splitString " " (lib.trim withoutPrefix);
      interpreter = builtins.head parts;
      args = builtins.tail parts;
    in
    if lib.hasPrefix "#!" line then
      {
        inherit interpreter args;
        isEnv = interpreter == "/usr/bin/env";
        resolvedInterpreter =
          if interpreter == "/usr/bin/env" && args != [ ] then builtins.head args else interpreter;
      }
    else
      null;
in
{
  parse =
    text:
    let
      first = builtins.head (lib.splitString "\n" text);
    in
    parseShebang first;

  isBash =
    text:
    let
      parsed = parseShebang (builtins.head (lib.splitString "\n" text));
    in
    parsed != null
    && builtins.elem parsed.resolvedInterpreter [
      "bash"
      "/bin/bash"
      "/usr/bin/bash"
    ];

  isSh =
    text:
    let
      parsed = parseShebang (builtins.head (lib.splitString "\n" text));
    in
    parsed != null
    && builtins.elem parsed.resolvedInterpreter [
      "sh"
      "/bin/sh"
      "/usr/bin/sh"
    ];

  isShellScript =
    text:
    let
      parsed = parseShebang (builtins.head (lib.splitString "\n" text));
    in
    parsed != null
    && builtins.elem parsed.resolvedInterpreter [
      "bash"
      "/bin/bash"
      "/usr/bin/bash"
      "sh"
      "/bin/sh"
      "/usr/bin/sh"
    ];
}
