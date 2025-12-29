{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nix-ai-tools.opencode
  ];

  xdg.configFile."opencode" = {
    source = ./.;
    recursive = true;
  };

  programs.hm-ricing-mode.apps.opencode = {
    dest_dir = ".config/opencode";
    source_dir = "$HOME/.config/home-manager/modules/opencode";
    type = "symlink";
  };
}
