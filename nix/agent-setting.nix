# Project infrastructure standards from set-and-setting: .editorconfig,
# .gitattributes, .gitignore (composed from fragments). Unlike the skill set
# (gitignored out-link), these are tracked root files -- materialized with
# `nix build .#agent-setting && result/bin/sync-setting`, then committed.
# Re-sync after `nix flake update set-and-setting`; the setting-drift check
# fails if the committed files fall behind.
{ pkgs, set-and-setting }:
set-and-setting.lib.mkSetting {
  inherit pkgs;
  gitignore = [
    "nix"
    "claude"
    "setting"
  ];
}
