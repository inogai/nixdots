{
  config,
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    skim
    vivid
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
  };

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      completions.algorithm = "fuzzy";
    };
    extraConfig = ''
      $env.LS_COLORS = (vivid generate catppuccin-mocha)
    '';
    environmentVariables = config.home.sessionVariables;
    shellAliases = config.home.shellAliases;
    plugins = with pkgs.nushellPlugins; [
      skim
    ];
  };

  programs.atuin = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      enter_accept = false;
    };
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableNushellIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = {
      add_newline = false;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
      time.disabled = false;
      format = lib.concatStringsSep "" [
        "$all"
        "$time"
        "$line_break"
        "$jobs"
        "$character"
      ];
    };
  };

  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };
}
