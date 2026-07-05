{
  config,
  lib,
  pkgs,
  yaziFlavors,
  ...
}:
let
  cfg = config.my.modules.yazi;
  shellPopup = cmd: "shell -- zellij run --floating -- ${cmd}";
in
{
  options.my.modules.yazi = {
    enable = lib.mkEnableOption "Yazi File Manager";
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      enableNushellIntegration = true;

      settings = {
        mgr = {
          sort_by = "mtime";
          sort_reverse = true;
          linemode = "none";
        };
      };

      keymap = {
        mgr = {
          prepend_keymap = [
            {
              on = [
                "<C-x>"
                "<Space>"
              ];
              run = [
                "toggle"
                "arrow prev"
              ];
            }
            {
              on = [ "<S-p>" ];
              run = [
                "enter"
                "paste"
                "leave"
              ];
              desc = "Paste into Folder";
            }
            {
              on = [ "R" ];
              run = "rename --hovered --empty=stem --cursor=start";
              desc = "Rename File";
            }
          ];
        };
      };

      flavors = {
        inherit (yaziFlavors)
          catppuccin-mocha
          catppuccin-latte
          ;
      };

      theme.flavor = {
        dark = "catppuccin-mocha";
        light = "catppuccin-latte";
      };
    };
  };
}
