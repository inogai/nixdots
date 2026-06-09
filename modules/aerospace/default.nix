{
  config,
  lib,
  pkgs,
  ...
}:
let
  workspaces = [
    {
      key = "1";
      name = "1:web";
      monitor = 1;
    }
    {
      key = "2";
      name = "2:dev";
      monitor = 2;
    }
    {
      key = "3";
      name = "3";
      monitor = 1;
    }
    {
      key = "4";
      name = "4";
      monitor = 2;
    }
    {
      key = "5";
      name = "5";
      monitor = 1;
    }
    {
      key = "6";
      name = "6";
      monitor = 2;
    }
    {
      key = "7";
      name = "7";
      monitor = 1;
    }
    {
      key = "8";
      name = "8";
      monitor = 2;
    }
    {
      key = "9";
      name = "9";
      monitor = 1;
    }
    {
      key = "0";
      name = "10";
      monitor = 2;
    }
  ];
  # Group workspace names by monitor
  workspaceNamesByMonitor =
    monitor: builtins.map (ws: ws.name) (builtins.filter (ws: ws.monitor == monitor) workspaces);

  # fn: a -> { name = string; value = any; }
  mapToAttrs = list: fn: builtins.listToAttrs (builtins.map fn list);
  modeFn = f: [
    "mode ${f}"
    "exec-and-forget noti -t 'Aerospace' 'Mode ${f}'"
  ];
  exec = f: "exec-and-forget ${f}";
in
{
  programs.aerospace = {
    enable = true;
    launchd.enable = true;
    settings = {
      after-login-command = [ ];

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
      on-focused-monitor-changed = [ "move-mouse monitor-lazy-center" ];
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
            alt-d = exec "open -a Raycast";
            alt-f = "layout floating tiling";
            alt-g = "resize smart -50";
            alt-shift-g = "resize smart +50";
            # Direction keys (from lib/keybindings.nix)
            "alt-h" = "focus left";
            "alt-j" = "focus down";
            "alt-k" = "focus up";
            "alt-l" = "focus right";
            "alt-shift-h" = "move left";
            "alt-shift-j" = "move down";
            "alt-shift-k" = "move up";
            "alt-shift-l" = "move right";
            alt-semicolon = "balance-sizes";
            alt-enter = exec "kitty -1 -d ~/";
            alt-esc = "focus-monitor --wrap-around next";
            alt-shift-esc = [
              "move-node-to-monitor --wrap-around next"
              "focus-monitor --wrap-around next"
            ];
            # alt-c = exec "open raycast://extensions/thomas/color-picker/pick-color";
            # alt-v = exec "open raycast://extensions/raycast/clipboard-history/clipboard-history";
            # alt-b = exec "open raycast://extensions/jomifepe/bitwarden/search";
            alt-x = "close";
            alt-space = exec "open -a Raycast";
          }
          # Workspace keys (from lib/keybindings.nix)
          // mapToAttrs workspaces (ws: {
            name = "alt-${ws.key}";
            value = [
              "workspace ${ws.name}"
              "exec-and-forget noti -t 'Aerospace' 'Switched to workspace ${ws.name}'"
            ];
          })
          // mapToAttrs workspaces (ws: {
            name = "alt-shift-${ws.key}";
            value = [
              "move-node-to-workspace ${ws.name}"
              "workspace ${ws.name}"
              "exec-and-forget noti -t 'Aerospace' 'Moved window to workspace ${ws.name}'"
            ];
          });
        };
        service = {
          binding = {
            esc = [ "reload-config" ] ++ modeFn "main";
          };
        };
      };

      workspace-to-monitor-force-assignment =
        { }
        // lib.genAttrs (workspaceNamesByMonitor 1) (_: [ 1 ])
        // lib.genAttrs (workspaceNamesByMonitor 2) (_: [
          2 # prioritize monitor 2, if not available, use monitor 1
          1
        ]);

      "on-window-detected" = [
        {
          "if".window-title-regex-substring = "^fzfmenu$";
          run = [ "layout floating" ];
        }
      ];

      exec = {
        inherit-env-vars = true;
        env-vars.PATH = "${config.home.homeDirectory}/.nix-profile/bin:/usr/bin:/usr/sbin:/bin:/sbin";
      };
    };
  };
}
