{ config, ... }:
let
  palette = config.colorScheme.palette;
  toJankyBordersColor = color: "0xff${color}";
in
{
  services.jankyborders = {
    enable = true;
    settings = {
      active_color = toJankyBordersColor palette.base0E;
      inactive_color = toJankyBordersColor palette.base04;
      style = "round";
      hidpi = "off";
      width = 8;
    };
  };
}
