{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.fonts;
in
{
  options.my.modules.fonts.enable = lib.mkEnableOption "fonts";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      victor-mono
      ibm-plex
      nerd-fonts.symbols-only
      lilex
      nerd-fonts.lilex

      noto-fonts-cjk-serif-static

      inter
    ];
  };
}
