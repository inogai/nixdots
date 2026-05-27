{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    # jetbrains-mono
    victor-mono
    ibm-plex
    nerd-fonts.symbols-only
    lilex
    nerd-fonts.lilex

    noto-fonts-cjk-serif-static

    inter
  ];
}
