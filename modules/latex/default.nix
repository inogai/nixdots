{
  config,
  pkgs,
  ...
}: {
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs) scheme-medium amsmath booktabs times cite silence etoolbox caption url eepic;
    };
  };
}
