{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.my.modules.pi = {
    enable = lib.mkEnableOption "pi coding agent";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nix-ai-tools.pi;
      defaultText = lib.literalExpression "pkgs.nix-ai-tools.pi";
      description = "pi package to install.";
    };
  };

  config = lib.mkIf config.my.modules.pi.enable {
    # Only install the pi binary. All ~/.pi/agent config (settings.json,
    # models.json, extensions, skills) is managed as a live git repo at
    # ~/.pi with git-crypt for secrets. See github.com/inogai/pi-config.
    # Nothing under ~/.pi is declared here, so pi can rewrite its own
    # settings.json at runtime without fighting home-manager symlinks.
    home.packages = [ config.my.modules.pi.package ];
  };
}