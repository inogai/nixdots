{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    fzf
    nur.repos.inogai.fzfmenu
  ];

  xdg.configFile."fzfmenu" = {
    source = ./.;
    recursive = true;
  };

  programs.hm-ricing-mode.apps.fzfmenu = {
    dest_dir = ".config/fzfmenu";
    source_dir = "$HOME/.config/home-manager/modules/fzfmenu";
    type = "symlink";
  };
}
