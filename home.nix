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
        handy
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

        gpg.pinentry = "touchid";
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
        clipboard.backend = "win32yank";
        wsl.enable = true;
        zellij.keyLayout = "windows";

        gpg.pinentry = "curses";
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
    pkgs.nodejs
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "raycast"
      "shottr"
    ];

  wrappers.neovim.enable = true;

  my.modules = lib.mkMerge [
    # Shared across every preset.
    {
      cli-utils.enable = true;
      gpg.enable = true;
      shell.enable = true;
      tui-apps.enable = true;
      yazi.enable = true;
      zellij.enable = true;

      pi.enable = true;
    }
    # Preset-specific toggles.
    cfg.modules
  ];
}
