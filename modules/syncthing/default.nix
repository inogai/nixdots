{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.syncthing;
in
{
  options.my.modules.syncthing.enable = lib.mkEnableOption "syncthing file synchronization";

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      enable = true;
      tray.enable = false;
    };
  };
}
