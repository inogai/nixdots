{
  config,
  lib,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    openssh
    podman-compose
  ];

  services.podman = {
    enable = true;

    settings.containers = {
      engine = {
        compose_providers = ["podman-compose"];
        compose_warning_logs = false;
      };
    };
  };
}
