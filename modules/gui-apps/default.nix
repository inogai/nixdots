{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    prismlauncher
    bruno
    raycast
    nur.repos.inogai.ray-raycast
  ];

  home.file."Library/Application Support/carapace/bridges.yaml".text = ''
    ray: cobra
  '';
}
