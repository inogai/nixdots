{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.wsl;
in
{
  options.my.modules.wsl = {
    enable = lib.mkEnableOption "WSL integration: open files and URLs in Windows applications";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.wsl-open;
      defaultText = lib.literalExpression "pkgs.wsl-open";
      description = "wsl-open package to install.";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      # Provides `wsl-open`, which opens files (pdf, images, ...) and URLs
      # in their Windows default application from inside WSL.
      cfg.package

      # Expose the same opener as `xdg-open` so Linux tools (yazi, neovim,
      # mailers, ...) that shell out to xdg-open route through Windows.
      (pkgs.writeShellScriptBin "xdg-open" ''
        exec ${lib.getExe cfg.package} "$@"
      '')
    ];

    # Tell tools that look for a browser to use the same opener.
    home.sessionVariables = {
      BROWSER = "xdg-open";
    };
  };
}