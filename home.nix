{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default
    ./modules/aerospace
    ./modules/cli-utils
    ./modules/fonts
    ./modules/gui-apps
    ./modules/jankyborders
    ./modules/kitty
    ./modules/latex
    ./modules/opencode
    ./modules/podman
    ./modules/qutebrowser
    ./modules/shell
    ./modules/sketchybar
    ./modules/syncthing
    ./modules/tui-apps
    ./modules/yazi
    ./modules/zellij
  ];

  # colorScheme = import ./lib/colorscheme.nix;
  # colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
  colorScheme = nix-colors.colorSchemes.catppuccin-mocha;

  home.username = "inogai";
  home.homeDirectory = "/Users/inogai";

  home.stateVersion = "26.05";
  home.packages = [];
  home.file = {};

  news.display = "silent";

  programs.home-manager.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "raycast"
      "shottr"
    ];
}
