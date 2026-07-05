{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.zellij;
in
{
  options.my.modules.zellij.enable = lib.mkEnableOption "zellij terminal workspace";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zellij
    ];

    xdg.configFile."zellij" = {
      source = ./.;
      recursive = true;
    };
  };
}
