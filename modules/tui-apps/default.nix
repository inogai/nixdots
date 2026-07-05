{
  config,
  pkgs,
  ...
}:
{
  programs.lazygit = {
    enable = true;
    settings = {
      overrideGpg = true;
    };
  };
}
