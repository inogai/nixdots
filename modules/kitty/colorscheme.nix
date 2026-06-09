{
  config,
  lib,
  ...
}:
let
  pal = config.colorScheme.palette;
in
{
  settings = {
    selection_foreground = "#${pal.base05}";
    selection_background = "#${pal.base02}";
    background = "#${pal.base00}";
    foreground = "#${pal.base05}";
    color0 = "#${pal.base00}";
    color1 = "#${pal.base08}";
    color2 = "#${pal.base0B}";
    color3 = "#${pal.base0A}";
    color4 = "#${pal.base0D}";
    color5 = "#${pal.base0E}";
    color6 = "#${pal.base0C}";
    color7 = "#${pal.base05}";
    color8 = "#${pal.base03}";
    color9 = "#${pal.base08}";
    color10 = "#${pal.base0B}";
    color11 = "#${pal.base0A}";
    color12 = "#${pal.base0D}";
    color13 = "#${pal.base0E}";
    color14 = "#${pal.base0C}";
    color15 = "#${pal.base07}";
    cursor = "#${pal.base05}";
    cursor_text_color = "#${pal.base00}";
    url_color = "#${pal.base0D}";
    active_tab_foreground = "#${pal.base05}";
    active_tab_background = "#${pal.base02}";
    inactive_tab_foreground = "#${pal.base04}";
    inactive_tab_background = "#${pal.base01}";
  };
}
