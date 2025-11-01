{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    vivid
    zoxide
  ];

  programs.nushell = {
    enable = true;
    settings = {
      show_banner = false;
      completions.algorithm = "fuzzy";
    };
    extraConfig = builtins.readFile (pkgs.runCommand "zoxide-init" {} "${pkgs.zoxide}/bin/zoxide init nushell > $out") + ''
      $env.LS_COLORS = (vivid generate catppuccin-mocha)
    '';
    shellAliases = {
      nv = "nvim";
    };
  };

  programs.carapace = {
      enable = true;
      enableNushellIntegration = true;
  };

  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[➜](bold green)";
        error_symbol = "[➜](bold red)";
      };
    };
  };
  
  programs.atuin = {
    enable = true;
    settings = {
    };
  };
}