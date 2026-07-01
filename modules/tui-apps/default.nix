{
  config,
  pkgs,
  ...
}:
{
  home.packages = with pkgs; [
    (writeShellScriptBin "nvim-inogai" ''
      exec ~/flakes/nvim-inogai/result/bin/nvim-inogai "$@"
    '')
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      overrideGpg = true;
    };
  };
}
