{
  config,
  lib,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    openssh
    docker
    podman-compose
    docker-compose
    docker-credential-helpers
  ];

  services.podman = {
    enable = false;

    settings.containers = {
      engine = {
        compose_providers = [ "docker-compose" ];
        # compose_providers = ["podman-compose"];
        compose_warning_logs = false;
      };
    };
  };
}
