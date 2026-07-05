{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.sketchybar;
  palette = config.colorScheme.palette;
in
{
  options.my.modules.sketchybar.enable = lib.mkEnableOption "sketchybar status bar";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      sbar-inogai
      sketchybar-app-font
    ];

    xdg.configFile."sbar-inogai/config.lua".text = "return ${
      lib.generators.toLua { } (builtins.mapAttrs (key: value: "0xff${value}") palette)
    }";
  };
}
