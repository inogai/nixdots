{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    zulu25
    prismlauncher
    # bruno
    raycast
    shottr
  ];
}
