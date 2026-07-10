{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.pi;

  # Local resources that pi auto-discovers from its conventional directories.
  # Sourced as real files from this module so the content stays out of Nix
  # strings and is easy to edit and version.
  extensionDir = ./extension;
  skillDir = ./skill;

  # Packages managed by `pi install` (npm/git sources). Listed in settings.json
  # so pi reconciles them on startup. pi installs missing packages automatically
  # after the project is trusted; here they are global (user-scope) packages.
  packages = [
    "npm:pi-web-access"
    "npm:@gotgenes/pi-permission-system"
  ];

  # Global settings.json written by Home Manager. Anything pi manages at
  # runtime (lastChangelogVersion) is intentionally left out so that this file
  # stays the single source of truth. Sensitive files (auth.json, models.json,
  # sessions, npm cache) are left to pi itself to manage.
  settings = {
    inherit (cfg) theme;
    inherit packages;
  };
in
{
  options.my.modules.pi = {
    enable = lib.mkEnableOption "pi coding agent";

    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.nix-ai-tools.pi;
      defaultText = lib.literalExpression "pkgs.nix-ai-tools.pi";
      description = "pi package to install.";
    };

    theme = lib.mkOption {
      type = lib.types.str;
      default = "dark/dark";
      description = "pi theme name.";
    };
  };

  config = lib.mkIf cfg.enable {
    # ~/.pi/agent/settings.json — fully declarative.
    home.file.".pi/agent/settings.json".text = builtins.toJSON settings;

    # Hypa CLI shim. The @hypabolic/pi-hypa extension intercepts bash calls and
    # rewrites them to pipe through `hypa`, but the postinstall script that
    # normally creates this shim never runs under pi's npm. This shim delegates
    # to a system-level `hypa` on PATH (if present and not itself), falling back
    # to the bundled hypa binary from the pi npm directory.
    #
    # Built via writeShellApplication (makeWrapper) so `node` is found without
    # polluting ~/.local/bin. It installs into the Home Manager profile bin,
    # which is already on PATH, so no session-variable PATH hack is needed.
    home.packages = [
      cfg.package
    ];

    # Declarative local extensions and skills. Sourced as real files from this
    # module and symlinked into ~/.pi/agent so pi auto-discovers them via its
    # conventional directories (extensions/<name>/index.ts, skills/<name>/SKILL.md).
    # Mutable state (auth.json, models.json, sessions/, npm/) lives alongside
    # and is left untouched by Home Manager.
    home.file.".pi/agent/extensions/semantic-commit/index.ts".source =
      "${extensionDir}/semantic-commit/index.ts";
    home.file.".pi/agent/skills/semantic-commit/SKILL.md".source =
      "${skillDir}/semantic-commit/SKILL.md";
  };
}
