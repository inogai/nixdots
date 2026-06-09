{
  lib,
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    nix-ai-tools.opencode
  ];

  xdg.configFile."opencode" = {
    source = ./.;
    recursive = true;
  };
}
