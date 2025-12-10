{
  config,
  pkgs,
  ...
}: {
  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      inherit (tpkgs)
        scheme-medium
        # Core CTAN packages for CVPR template
        times # times
        tools # xspace
        xcolor # xcolor
        graphics # graphicx, keyval, color
        amsmath # amsmath
        amsfonts # amssymb
        booktabs # booktabs
        natbib # natbib
        silence # silence
        etoolbox # etoolbox
        caption # caption, subcaption
        url # url
        lineno # lineno
        # Additional packages
        enumitem # enumitem
        cleveref # cleveref
        # Existing packages
        cite
        eepic
        xecjk
        environ
        ;
    };
  };
}
