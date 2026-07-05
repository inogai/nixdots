{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}:
{

  # colorScheme = import ./lib/colorscheme.nix;
  # colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
  colorScheme = nix-colors.colorSchemes.catppuccin-mocha;

  home.username = "inogai";
  home.homeDirectory = "/Users/inogai";
  home.stateVersion = "26.05";

  news.display = "silent";

  programs.home-manager.enable = true;

  home.file = { };

  home.packages = with pkgs; [
    raycast
    shottr
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "raycast"
      "shottr"
    ];

  my.modules = {
    # Software Modules - Only for MacOS
    aerospace.enable = true;
    fonts.enable = true;
    jankyborders.enable = true;
    kitty.enable = true;
    kitty.mapShiftSpaceToCxSpace = true;
    qutebrowser.enable = true;
    sketchybar.enable = true;
    syncthing.enable = true;

    cli-utils.enable = true;
    nvim.enable = true;
    shell.enable = true;
    tui-apps.enable = true;
    yazi.enable = true;
    zellij.enable = true;
  };
}
