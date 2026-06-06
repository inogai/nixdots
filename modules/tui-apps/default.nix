{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (writeShellScriptBin "nvim-inogai" ''
      exec ~/flakes/nvim-inogai/result/bin/nvim-inogai "$@"
    '')

    (
      writeShellScriptBin "nvim" ''
        export NVIM_APPNAME="nvim-lazy"
        exec ${pkgs.neovim}/bin/nvim "$@"
      ''
    )
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      overrideGpg = true;
    };
  };
}
