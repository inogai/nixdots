{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zellij
  ];

  xdg.configFile."zellij" = {
    source = ./.;
    recursive = true;
  };

  programs.hm-ricing-mode.apps.zellij = {
    dest_dir = ".config/zellij";
    source_dir = "$HOME/.config/home-manager/modules/zellij";
    type = "symlink";
  };
}
