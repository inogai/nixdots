{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.clipboard;
in
{
  options.my.modules.clipboard = {
    enable = lib.mkEnableOption "system clipboard configuration (WSL, Wayland, X11, OSC 52)";

    backend = lib.mkOption {
      type = lib.types.enum [
        "auto"
        "wsl"
        "wl"
        "xclip"
        "osc52"
      ];
      default = "auto";
      description = ''
        Clipboard backend to use.
        - auto:  auto-detect based on environment
        - wsl:   clip.exe / powershell.exe (Windows Subsystem for Linux)
      '';
    };

    extraPackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = "Extra packages to install for clipboard support.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages =
      [ ]
      ++ lib.optionals (cfg.backend == "wl" || cfg.backend == "auto") [ pkgs.wl-clipboard ]
      ++ lib.optionals (cfg.backend == "xclip" || cfg.backend == "auto") [ pkgs.xclip ]
      ++ cfg.extraPackages;

    # Set a global variable so Neovim and other tools can discover the
    # preferred clipboard backend without re-detecting.
    home.sessionVariables = lib.mkIf (cfg.backend != "auto") {
      CLIPBOARD_BACKEND = cfg.backend;
    };
  };
}
