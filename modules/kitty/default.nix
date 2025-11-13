{
  config,
  pkgs,
  ...
}: let
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
    settings.font_family = "IBM Plex Mono";
    extraConfig = ''
      modify_font baseline 0
      modify_font cell_height 0px
    '';
  };
in {
  programs.kitty = mergeConfig ibmPlexMonoConf {
    enable = true;
    settings = {
      shell = "zsh -ic ${pkgs.nushell}/bin/nu";
      font_size = 20;

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

      # Theme: Gruvbox Dark
      selection_foreground = "#ebdbb2";
      selection_background = "#d65d0e";
      background = "#282828";
      foreground = "#ebdbb2";
      color0 = "#3c3836";
      color1 = "#cc241d";
      color2 = "#98971a";
      color3 = "#d79921";
      color4 = "#458588";
      color5 = "#b16286";
      color6 = "#689d6a";
      color7 = "#a89984";
      color8 = "#928374";
      color9 = "#fb4934";
      color10 = "#b8bb26";
      color11 = "#fabd2f";
      color12 = "#83a598";
      color13 = "#d3869b";
      color14 = "#8ec07c";
      color15 = "#fbf1c7";
      cursor = "#bdae93";
      cursor_text_color = "#665c54";
      url_color = "#458588";
      active_tab_foreground = "#eeeeee";
      active_tab_background = "#d65d0e";
      inactive_tab_foreground = "#ebdbb2";
      inactive_tab_background = "#202020";
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
