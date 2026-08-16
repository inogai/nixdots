{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.modules.direnv;
in
{
  options.my.modules.direnv.enable = lib.mkEnableOption "direnv with nix-direnv";

  config = lib.mkIf cfg.enable {
    programs.direnv = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
  };
}
