{
  lib,
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nix-ai-tools.opencode
  ];

  home.file.".config/opencode/opencode.jsonc".source = ./opencode.jsonc;

  home.file.".config/opencode/command/commit.md".source = ./commit.md;
}
