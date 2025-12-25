{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    nvim-inogai
  ];

  programs.lazygit = {
    enable = true;
    settings = {
      overrideGpg = true;
    };
  };
}
