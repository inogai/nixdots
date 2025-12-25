{...}: {
  programs.lazygit = {
    enable = true;
    settings = {
      overrideGpg = true;
    };
  };
}
