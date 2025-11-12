{
  lib,
  config,
  pkgs,
  ...
}: let
  fzfOptions = import ../../lib/fzf.nix;
  addQuotes = str: ''"$'${str}'"'';
  joinQuoted = strs: lib.concatStringsSep ", " (lib.map addQuotes strs);
  kittyConf = let
    # Fzfmenu-specific kitty settings that override the main config
    fzfmenuKittyOverrides = {
      font_size = 30;
      window_margin_width = "6 0 4";
      remember_window_size = false;
      initial_window_width = 1000;
      initial_window_height = 800;
    };

    # Convert settings to kitty config format
    toKittyConfig = lib.generators.toKeyValue {
      mkKeyValue = key: value: let
        valueStr =
          if lib.isBool value
          then
            if value
            then "yes"
            else "no"
          else toString value;
      in "${key} ${valueStr}";
    };
  in
    pkgs.writeText "fzfmenu-kitty.conf" ''
      ${config.programs.kitty.extraConfig}
      ${toKittyConfig fzfmenuKittyOverrides}
    '';
in {
  home.packages = with pkgs; [
    fzf
    nur.repos.inogai.fzfmenu
  ];

  home.file.".config/fzfmenu/config.toml".text = ''
    terminal = "${pkgs.kitty}/bin/kitty"
    arguments = [
      '--single-instance',
      '--instance-group',
      'fzfmenu',
      '--title',
      'fzfmenu',
      '--config',
      '${kittyConf}',
    ]
    fzf_arguments = [${joinQuoted fzfOptions.options}]

    [[plugins]]
    name = "app_launcher"
    description = "Launch applications based on your desktop environment."
    prefix = ""
    picker = "fd -d2 -L '\\.app$' /Applications $HOME/Applications /System/Applications -x echo {/}"
    runner = "/usr/bin/open -a '{}'"

    [[plugins]]
    name = "focus"
    description = "Focus an aerospace window"
    prefix = "fo "
    picker = "aerospace list-windows --all"
    runner = "echo {} | cut -d| -f1 | xargs -I{id} aerospace focus --window-id {id}"
  '';
}
