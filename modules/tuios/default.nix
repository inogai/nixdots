{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    tuios.tuios
  ];

  xdg.configFile."tuios/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink ./config.toml;
}
