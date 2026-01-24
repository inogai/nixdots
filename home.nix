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
    ./modules/kitty
    ./modules/shell
    ./modules/yazi
    ./modules/fzfmenu
    ./modules/qutebrowser
    ./modules/opencode
    ./modules/latex
    ./modules/fonts
    ./modules/gui-apps
    ./modules/cli-utils
    ./modules/tmux
    ./modules/tui-apps
    ./modules/zellij
    ./modules/podman
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
  programs.hm-ricing-mode.enable = true;

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "raycast"
    ];
}
