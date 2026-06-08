# Fails if the committed standard files (.editorconfig, .gitattributes,
# .gitignore) drift from the agent-setting derivation -- e.g. after a
# set-and-setting bump without re-running sync-setting.
{
  pkgs,
  set-and-setting,
  settingSet,
}:
set-and-setting.lib.mkSettingDriftCheck {
  inherit pkgs settingSet;
  projectRoot = ../.;
}
