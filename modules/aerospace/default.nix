{
  config,
  pkgs,
  ...
}: let
  palette = config.colorScheme.palette;
  toJankyBordersColor = color: "0xff${color}"; # 0xff<color>

  modeFn = f: ["mode ${f}" "exec-and-forget noti -t 'Aerospace' 'Mode ${f}'"];
in {
  home.packages = with pkgs; [
    sbar-inogai
    sketchybar-app-font
  ];

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
          binding = {
            alt-slash = "layout tiles accordion";
            alt-comma = "layout horizontal vertical";
            alt-h = "focus left";
            alt-j = "focus down";
            alt-k = "focus up";
            alt-l = "focus right";
            alt-f = "layout floating tiling";
            alt-minus = "resize smart -50";
            alt-equal = "resize smart +50";
            "alt-shift-minus" = "balance-sizes";
            "alt-shift-equal" = "balance-sizes";
            alt-backtick = "focus-monitor --wrap-around next";
            "alt-shift-backtick" = [
              "move-node-to-monitor --wrap-around next"
              "focus-monitor --wrap-around next"
            ];
            alt-tab = "exec-and-forget fzfmenu -q=\"fo \"";
            alt-1 = "workspace 1";
            alt-2 = "workspace 2";
            alt-3 = "workspace 3";
            alt-w = "workspace W";
            alt-e = "workspace E";
            alt-a = "workspace A";
            alt-s = "workspace S";
            "alt-shift-1" = ["move-node-to-workspace 1" "workspace 1"];
            "alt-shift-2" = ["move-node-to-workspace 2" "workspace 2"];
            "alt-shift-3" = ["move-node-to-workspace 3" "workspace 3"];
            "alt-shift-w" = ["move-node-to-workspace W" "workspace W"];
            "alt-shift-e" = ["move-node-to-workspace E" "workspace E"];
            "alt-shift-a" = ["move-node-to-workspace A" "workspace A"];
            "alt-shift-s" = ["move-node-to-workspace S" "workspace S"];
            alt-q = "exec-and-forget kitty -1 -d ~/";
            alt-x = "close";
            alt-d = "exec-and-forget fzfmenu";
            alt-semicolon = modeFn "arrangement";
          };
        };
        arrangement = {
          binding = {
            esc = modeFn "main";
            h = "move left";
            j = "move down";
            k = "move up";
            l = "move right";
            alt-h = "join-with left";
            alt-j = "join-with down";
            alt-k = "join-with up";
            alt-l = "join-with right";
          };
        };
        service = {
          binding = {
            esc = ["reload-config"] ++ modeFn "main";
          };
        };
      };

      workspace-to-monitor-force-assignment = {
        "1" = 1;
        "2" = [2 1];
        "3" = [2 1];
        W = 1;
        E = [2 1];
        A = 1;
        S = [2 1];
      };

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
