{
  config,
  lib,
  pkgs,
  ...
}: let
  palette = config.colorScheme.palette;
  toJankyBordersColor = color: "0xff${color}"; # 0xff<color>

  # fn: a -> { name = string; value = any; }
  mapToAttrs = list: fn:
    builtins.listToAttrs (builtins.map fn
      list);
  modeFn = f: ["mode ${f}" "exec-and-forget noti -t 'Aerospace' 'Mode ${f}'"];
  exec = f: "exec-and-forget ${f}";
in {
  home.packages = with pkgs; [
    sbar-inogai
    sketchybar-app-font
  ];

  xdg.configFile."sbar-inogai/config.lua".text = ''
    return ${
      lib.generators.toLua {} (builtins.mapAttrs (key: value: "0xff${value}") palette)
    }'';

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

  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      after-login-command = [];

      after-startup-command = [
        "exec-and-forget sbar-inogai"
      ];

      exec-on-workspace-change = [
        "${pkgs.bash}/bin/bash"
        "-c"
        "sbar-inogai --trigger aerospace_workspace_change AEROSPACE_FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE AEROSPACE_PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE"
      ];

      start-at-login = true; # NOTE: will be overridden by `launchd.enable`
      enable-normalization-flatten-containers = true;
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      default-root-container-layout = "tiles";
      default-root-container-orientation = "auto";
      on-focused-monitor-changed = ["move-mouse monitor-lazy-center"];
      automatically-unhide-macos-hidden-apps = true;

      key-mapping.preset = "qwerty";

      gaps = {
        inner.horizontal = 12;
        inner.vertical = 8;
        outer.left = 4;
        outer.bottom = 4;
        outer.top = 24; # 20 (sbar) + 4 (borders)
        outer.right = 4;
      };

      mode = {
        "main" = {
          binding =
            {
              alt-slash = "layout tiles accordion";
              alt-comma = "layout horizontal vertical";
              alt-d = exec "open -a Raycast";
              alt-f = "layout floating tiling";
              alt-g = "resize smart -50";
              alt-shift-g = "resize smart +50";
              alt-h = "focus left";
              alt-j = "focus down";
              alt-k = "focus up";
              alt-l = "focus right";
              alt-shift-h = "move left";
              alt-shift-j = "move down";
              alt-shift-k = "move up";
              alt-shift-l = "move right";
              alt-semicolon = "balance-sizes";
              alt-enter = exec "kitty -1 -d ~/";
              alt-esc = "focus-monitor --wrap-around next";
              alt-shift-esc = [
                "move-node-to-monitor --wrap-around next"
                "focus-monitor --wrap-around next"
              ];
              alt-c = exec "open raycast://extensions/thomas/color-picker/pick-color";
              alt-v = exec "open raycast://extensions/raycast/clipboard-history/clipboard-history";
              alt-b = exec "open raycast://extensions/jomifepe/bitwarden/search";
              alt-x = "close";
            }
            // mapToAttrs ["q" "w" "e" "r" "t" "y" "u" "i" "o" "p"] (k: {
              name = "alt-${k}";
              value = [
                "workspace ${k}"
                "exec-and-forget noti -t 'Aerospace' 'Switched to workspace ${k}'"
              ];
            })
            // mapToAttrs ["q" "w" "e" "r" "t" "y" "u" "i" "o" "p"] (k: {
              name = "alt-shift-${k}";
              value = [
                "move-node-to-workspace ${k}"
                "exec-and-forget noti -t 'Aerospace' 'Moved window to workspace ${k}'"
              ];
            });
        };
        service = {
          binding = {
            esc = ["reload-config"] ++ modeFn "main";
          };
        };
      };

      workspace-to-monitor-force-assignment =
        {}
        // lib.genAttrs ["q" "w" "e" "r" "t"] (_: [1])
        // lib.genAttrs ["y" "u" "i" "o" "p"] (_: [2 1]);

      "on-window-detected" = [
        {
          "if".window-title-regex-substring = "^fzfmenu$";
          run = ["layout floating"];
        }
      ];

      exec = {
        inherit-env-vars = true;
        env-vars.PATH = "${config.home.homeDirectory}/.nix-profile/bin:/usr/bin:/usr/sbin:/bin:/sbin";
      };
    };
  };
}
