{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    zulu25
    prismlauncher
    # bruno
    raycast
    shottr
  ];

  nixpkgs.config.allowUnfreePredicate =
    pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "raycast"
      "shottr"
    ];
}
