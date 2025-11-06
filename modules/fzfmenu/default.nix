{
  lib,
  config,
  pkgs,
  ...
}: let
  fzfOptions = import ../../lib/fzf.nix;
  addQuotes = str: "'${str}'";
  joinQuoted = strs: lib.concatStringsSep ", " (lib.map addQuotes strs);
  # TODO: inherit kitty config from module
  kittyConf = pkgs.writeText "fzfmenu-kitty.conf" ''
    font_size 28

    window_margin_width 6 0 4

    remember_window_size  no
    initial_window_width  1000
    initial_window_height 800
  '';
in {
  home.packages = with pkgs; [
    fzf
    # inogai.fzfmenu
  ];

  # TODO: use a less hacky config
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
    picker = "${pkgs.fd}/bin/fd '\\.app$' /Applications $HOME/Applications /System/Applications -x echo {/}"
    runner = "/usr/bin/open -a '{}'"
    bind_change = false
  '';
}
