{
  config,
  lib,
  pkgs,
  ...
}: let
  colorscheme = import ./colorscheme.nix {inherit config lib;};
  fonts = import ./fonts.nix;

  _mergeTwo = acc: conf:
    acc
    // {
      enable = true;
      settings = (acc.settings or {}) // (conf.settings or {});
      extraConfig = (acc.extraConfig or "") + "\n" + (conf.extraConfig or "");
    };

  mergeConfigs = configs:
    lib.foldl _mergeTwo {} configs;
in {
  programs.kitty = mergeConfigs [
    fonts.jetbrains
    fonts.nerdFontOverrides
    colorscheme
    {
      enable = true;
      settings = {
        shell = "zsh -ic 'zellij -l welcome'";
        font_size = 16;

        # OS Specific
        confirm_os_window_close = 0;
        hide_window_decorations = "titlebar-only";
        macos_option_as_alt = "yes";
        clear_all_shortcuts = "yes";

        # Remote Control
        allow_remote_control = "yes";
        listen_on = "unix:/tmp/kitty.sock";

        # Cursor Trail
        cursor_trail = 3;
        cursor_trail_decay = "0.3 0.6";
        cursor_trail_start_threshold = 0;

        # Background
        # background_opacity = 0.93;
        # background_blur = 32;
        # transparent_background_colors = "#202020@0.93 #181818@0.93 #333333@0.93";
      };
      extraConfig = ''
        # Underline Adjustments
        modify_font underline_position 130% - 2
        modify_font underline_thickness 2

        # Input Handling
        mouse_map left click ungrabbed mouse_handle_click selection link prompt
        mouse_map cmd+left release grabbed,ungrabbed mouse_handle_click link

        map cmd+c copy_to_clipboard
        map cmd+v paste_from_clipboard
        map cmd+r reload_config
        map cmd+shift+equal change_font_size current +1.0
        map cmd+shift+minus change_font_size current -1.0
        map shift+page_up scroll_page_up
        map shift+page_down scroll_page_down
      '';
    }
  ];

  programs.hm-ricing-mode.apps.kitty = {
    dest_dir = ".config/kitty";
    type = "backport";
  };
}
