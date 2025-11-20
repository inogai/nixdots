{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    docker
    docker-compose
    docker-credential-helpers
    colima
  ];
}

