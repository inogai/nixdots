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
  home.packages = [ ];
  home.file = { };

  news.display = "silent";

  programs.home-manager.enable = true;
}
