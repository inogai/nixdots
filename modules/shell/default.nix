{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    vivid
    zoxide
  ];

  home.sessionVariables = {
    EDITOR = "nvim-inogai";
  };

  home.shellAliases = {
    nv = "nvim-inogai";
    zj = "zellij";
  };

  programs.zsh = {
    enable = true;
    # Drop user to nushell if interactive
    # or `interactiveShellInit` for NixOS/nix-darwin
    initContent = ''
      if ! [ "$TERM" = "dumb" ]; then
        zellij -l welcome
        exec nu
      fi
    '';
  };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      completions.algorithm = "fuzzy";
    };
    extraConfig =
      builtins.readFile (pkgs.runCommand "zoxide-init" {} "${pkgs.zoxide}/bin/zoxide init nushell > $out")
      + ''
        $env.LS_COLORS = (vivid generate catppuccin-mocha)
      '';
    environmentVariables = config.home.sessionVariables;
    shellAliases = config.home.shellAliases;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };

  programs = {
    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      nix-direnv.enable = true;
    };
  };

  programs.atuin = {
    enable = true;
    settings = {
    };
  };
}
