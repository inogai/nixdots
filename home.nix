{
  config,
  lib,
  pkgs,
  nix-colors,
  preset,
  ...
}:
let
  # Presets control everything that differs between machines:
  #   username / homeDirectory, mac-only packages, and per-preset module
  #   toggles. Add a new machine by extending this attrset and adding a
  #   matching entry in `flake.nix#presets`.
  presets = {
    mac = {
      username = "inogai";
      homeDirectory = "/Users/inogai";
      # Mac-only GUI packages. Referenced via `pkgs` rather than a bare
      # `with` so this list stays valid outside of `home.packages`.
      packages = with pkgs; [
        raycast
        shottr
      ];
      modules = {
        aerospace.enable = true;
        fonts.enable = true;
        jankyborders.enable = true;
        kitty.enable = true;
        kitty.mapShiftSpaceToCxSpace = true;
        qutebrowser.enable = true;
        sketchybar.enable = true;
        syncthing.enable = true;

        cli-extras.enable = true;
        clipboard.enable = false;
        zellij.keyLayout = "mac";
      };
    };
    windows = {
      username = "alexlychen";
      homeDirectory = "/home/alexlychen";
      packages = [ ];
      modules = {
        # Mac-only modules are intentionally disabled here.

        cli-extras.enable = false;
        clipboard.enable = true;
        clipboard.backend = "wsl";
        zellij.keyLayout = "windows";
      };
    };
  };

  cfg = presets.${preset};
in
{

  # colorScheme = import ./lib/colorscheme.nix;
  # colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;
  colorScheme = nix-colors.colorSchemes.catppuccin-mocha;

  home.username = cfg.username;
  home.homeDirectory = cfg.homeDirectory;
  home.stateVersion = "26.05";

  news.display = "silent";

  programs.home-manager.enable = true;

  home.file = { };

  home.packages = cfg.packages ++ [
    pkgs.neovim
    pkgs.nodejs
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "raycast"
      "shottr"
    ];

  my.modules = lib.mkMerge [
    # Shared across every preset.
    {
      cli-utils.enable = true;
      shell.enable = true;
      tui-apps.enable = true;
      yazi.enable = true;
      zellij.enable = true;

      pi.enable = true;
      pi.theme = "dark/dark";
    }
    # Preset-specific toggles.
    cfg.modules
  ];
}
