{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    neovim
    # nvim-inogai
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      overrideGpg = true;
    };
  };
}
