{
  config,
  pkgs,
  ...
}: let
  palette = config.colorScheme.palette;
  toJankyBordersColor = color: "0xff${color}"; # 0xff<color>
  bordersPath = ".config/aerospace/borders";
in {
  home.packages = with pkgs; [
    bash
    aerospace
    jankyborders
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

  home.file.".config/aerospace/aerospace.toml" = {
    text = ''
      # https://nikitabobko.github.io/AeroSpace/commands
      # https://nikitabobko.github.io/AeroSpace/guide

      after-login-command = []

      after-startup-command = [
        # TODO: remove reliance on external config
        'exec-and-forget ${pkgs.sketchybar}/bin/sketchybar',
        'exec-and-forget ${config.home.homeDirectory}/${bordersPath}'
      ]

      exec-on-workspace-change = [
        '${pkgs.bash}/bin/bash',
        '-c',
        '${pkgs.sketchybar}/bin/sketchybar --trigger aerospace_workspace_change AEROSPACE_FOCUSED_WORKSPACE=$AEROSPACE_FOCUSED_WORKSPACE AEROSPACE_PREV_WORKSPACE=$AEROSPACE_PREV_WORKSPACE'
      ]

      start-at-login = true

      enable-normalization-flatten-containers = true
      enable-normalization-opposite-orientation-for-nested-containers = true

      accordion-padding = 30

      default-root-container-layout = 'tiles'
      default-root-container-orientation = 'auto'

      on-focused-monitor-changed = ['move-mouse monitor-lazy-center']

      automatically-unhide-macos-hidden-apps = true

      [key-mapping]
      preset = 'qwerty'

      [gaps]
      inner.horizontal = 12
      inner.vertical = 8
      outer.left = 8
      outer.bottom = 8
      outer.top = 40
      outer.right = 8

      [mode.main.binding]
      alt-slash = 'layout tiles accordion'
      alt-comma = 'layout horizontal vertical'

      alt-h = 'focus left'
      alt-j = 'focus down'
      alt-k = 'focus up'
      alt-l = 'focus right'

      alt-shift-h = 'move left'
      alt-shift-j = 'move down'
      alt-shift-k = 'move up'
      alt-shift-l = 'move right'

      alt-minus = 'resize smart -50'
      alt-equal = 'resize smart +50'
      alt-shift-minus = 'balance-sizes'
      alt-shift-equal = 'balance-sizes'

      alt-backtick = 'focus-monitor --wrap-around next'
      alt-shift-backtick = [
        'move-node-to-monitor --wrap-around next',
        'focus-monitor --wrap-around next',
      ]

      alt-tab = 'exec-and-forget fzfmenu -q="fo "'
      # alt-shift-tab = 'exec-and-forget s fzfmenu summon-window'

      alt-1 = 'workspace 1'
      alt-2 = 'workspace 2'
      alt-3 = 'workspace 3'
      alt-w = 'workspace W'
      alt-e = 'workspace E'
      alt-a = 'workspace A'
      alt-s = 'workspace S'

      alt-shift-1 = ['move-node-to-workspace 1', 'workspace 1']
      alt-shift-2 = ['move-node-to-workspace 2', 'workspace 2']
      alt-shift-3 = ['move-node-to-workspace 3', 'workspace 3']
      alt-shift-w = ['move-node-to-workspace W', 'workspace W']
      alt-shift-e = ['move-node-to-workspace E', 'workspace E']
      alt-shift-a = ['move-node-to-workspace A', 'workspace A']
      alt-shift-s = ['move-node-to-workspace S', 'workspace S']

      alt-q = 'exec-and-forget kitty -1 -d ~/'
      alt-x = 'close'
      alt-d = 'exec-and-forget fzfmenu'
      # alt-f = 'exec-and-forget s wm-float'
      alt-m = 'reload-config'

      alt-semicolon = [
        'mode arrangement',
      ]

      [mode.arrangement.binding]
      esc = [
        'reload-config',
        'mode main',
      ]

      h = 'join-with left'
      j = 'join-with down'
      k = 'join-with up'
      l = 'join-with right'

      [workspace-to-monitor-force-assignment]
      "1" = 1
      "2" = [2, 1]
      "3" = [2, 1]
      W = 1
      E = [2, 1]
      A = 1
      S = [2, 1]

      [[on-window-detected]]
      if.window-title-regex-substring = '^fzfmenu$'
      run = ['layout floating']

      [exec]
      inherit-env-vars = true

      [exec.env-vars]
      PATH = "${config.home.homeDirectory}/.nix-profile/bin:/usr/bin:/usr/sbin:/bin:/sbin"
    '';
  };
}
