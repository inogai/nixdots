{
  config,
  lib,
  pkgs,
  ...
}: let
  pal = config.colorScheme.palette;

  mergeConfig = confA: confB:
    confB
    // {
      settings = confB.settings // confA.settings;
      extraConfig = confB.extraConfig + "\n" + confA.extraConfig;
    };

  victorConf = {
    settings = {
      font_family = "Victor Mono";
      bold_font = "Victor Mono Bold";
      italic_font = "Victor Mono Medium Oblique";
      bold_italic_font = "Victor Mono Bold Oblique";
    };

    extraConfig = ''
      modify_font baseline -2
      modify_font cell_height 0px
    '';
  };
  jetBrainsConf = {
    settings = {
      font_family = "JetBrains Mono";
    };
    extraConfig = ''
      modify_font baseline 0
      modify_font cell_height 0px
    '';
  };
  ibmPlexMonoConf = {
    # settings.font_family = "IBM Plex Mono";
    settings.font_family = "Lilex";
    extraConfig = ''
      modify_font baseline 0
      modify_font cell_height 0px
    '';
  };
in {
  programs.kitty = mergeConfig jetBrainsConf {
    enable = true;
    settings = {
      shell = "zsh -ic ${pkgs.nushell}/bin/nu";
      # shell = "zsh -ic ${lib.getExe' pkgs.tuios.tuios "tuios"}";
      font_size = 18;

      # OS Specific
      confirm_os_window_close = 0;
      hide_window_decorations = "titlebar-only";
      macos_option_as_alt = "yes";

      # Remote Control
      allow_remote_control = "yes";

      # Cursor Trail
      cursor_trail = 3;
      cursor_trail_decay = "0.3 0.6";
      cursor_trail_start_threshold = 0;

      # Background
      background_opacity = 0.93;
      background_blur = 32;
      transparent_background_colors = "#202020@0.93 #181818@0.93 #333333@0.93";

      # Theme
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
    extraConfig = ''
      # Nerd font overrides
      symbol_map U+E5FA-U+E6B7 Symbols Nerd Font
      symbol_map U+E700-U+E8EF Symbols Nerd Font
      symbol_map U+ED00-U+F2FF Symbols Nerd Font
      symbol_map U+E200-U+E2A9 Symbols Nerd Font
      symbol_map U+F0001-U+F1AF0 Symbols Nerd Font
      symbol_map U+E300-U+E3E3 Symbols Nerd Font
      symbol_map U+F400-U+F533,U+2665,U+26A1 Symbols Nerd Font
      symbol_map U+E0A0-U+E0A2,U+E0B0-U+E0B3 Symbols Nerd Font
      symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CA,U+E0CC-U+E0D7 Symbols Nerd Font
      symbol_map U+23FB-U+23FE,U+2B58 Symbols Nerd Font
      symbol_map U+F300-U+F381 Symbols Nerd Font
      symbol_map U+E000-U+E00A Symbols Nerd Font
      symbol_map U+EA60-U+EC1E Symbols Nerd Font
      symbol_map U+276C-U+2771,U+2500-U+259F,U+EE00-U+EE0B Symbols Nerd Font

      allow_remote_control    yes
      listen_on               unix:/tmp/kitty.sock

      # Underline Adjustments
      modify_font underline_position 130% - 2
      modify_font underline_thickness 2

      # Input Handling
      mouse_map left click ungrabbed mouse_handle_click selection link prompt
      mouse_map cmd+left release grabbed,ungrabbed mouse_handle_click link

      map shift+page_up scroll_page_up
      map shift+page_down scroll_page_down
      map shift+space combine : send_key ctrl+x : send_key space
    '';
  };
}
