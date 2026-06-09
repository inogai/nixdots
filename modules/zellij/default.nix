{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zellij
  ];

  xdg.configFile."zellij" = {
    source = ./.;
    recursive = true;
  };
}
