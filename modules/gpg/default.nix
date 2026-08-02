{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.gpg;
in
{
  options.my.modules.gpg = {
    enable = lib.mkEnableOption "GnuPG and gpg-agent";

    pinentry = lib.mkOption {
      type = lib.types.enum [
        "touchid"
        "curses"
      ];
      description = ''
        Which pinentry program gpg-agent should use.
        - touchid: /opt/homebrew/bin/pinentry-touchid (Homebrew, macOS only)
        - curses:  pinentry-curses from nixpkgs
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gpg.enable = true;

    services.gpg-agent = {
      enable = true;
      defaultCacheTtl = 34560000;
      maxCacheTtl = 34560000;
      # pinentry-touchid is not in nixpkgs; reference the Homebrew build directly.
      extraConfig =
        "pinentry-program "
        + (if cfg.pinentry == "touchid" then
          "/opt/homebrew/bin/pinentry-touchid"
        else
          lib.getExe' pkgs.pinentry-curses "pinentry");
    };
  };
}
