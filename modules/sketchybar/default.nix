{
  config,
  lib,
  pkgs,
  ...
}: let
  palette = config.colorScheme.palette;
in {
  home.packages = with pkgs; [
    sbar-inogai
    sketchybar-app-font
  ];

  xdg.configFile."sbar-inogai/config.lua".text = "return ${
    lib.generators.toLua {} (builtins.mapAttrs (key: value: "0xff${value}") palette)
  }";
}
