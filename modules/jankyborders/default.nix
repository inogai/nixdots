{
  config,
  lib,
  ...
}:
let
  cfg = config.my.modules.jankyborders;
  palette = config.colorScheme.palette;
  toJankyBordersColor = color: "0xff${color}";
in
{
  options.my.modules.jankyborders.enable = lib.mkEnableOption "jankyborders window borders";

  config = lib.mkIf cfg.enable {
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
  };
}
