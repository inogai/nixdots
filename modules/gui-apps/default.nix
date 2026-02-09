{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    prismlauncher
    bruno
    raycast
    shottr
  ];
}
