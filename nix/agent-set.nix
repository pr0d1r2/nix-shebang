# Skill set built from set-and-setting, arranged into the layout Claude's
# @-imports expect: set.md at the root, set/ holding skills + concepts (so
# set.md's `@./set/...` lines resolve). Pure -- linkFarm symlinks into the
# store, out-linked into gitignored .claude/ by .envrc. No copy, no shell.
{ pkgs, set-and-setting }:
let
  set = set-and-setting.lib.mkSet {
    inherit pkgs;
    categories = [
      "opensource"
      "nix"
      "ci"
      "lefthook"
      "git"
      "test"
    ];
  };
in
pkgs.linkFarm "agent-set" [
  {
    name = "set.md";
    path = "${set}/set.md";
  }
  {
    name = "set/skills";
    path = "${set}/skills";
  }
  {
    name = "set/concepts";
    path = "${set}/concepts";
  }
]
