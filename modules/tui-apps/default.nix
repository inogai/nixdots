{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.tui-apps;
in
{
  options.my.modules.tui-apps.enable = lib.mkEnableOption "TUI applications (lazygit)";

  config = lib.mkIf cfg.enable {
    programs.lazygit = {
      enable = true;
      settings = {
        overrideGpg = true;
      };
    };
  };
}
