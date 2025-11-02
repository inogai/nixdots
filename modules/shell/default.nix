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

    programs = {
      direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };
    };
    
    programs.atuin = {
      enable = true;
      settings = {
      };
    };

    programs.yazi = {
      enable = true;
      enableNushellIntegration = true;

      settings = {
        mgr = {
          show_hidden = true;
          sort_by = "alphabetical";
        };
      };

      keymap = {
        mgr = {
          prepend_keymap = [
            { on = ["<C-x>" "<Space>"]; run = ["toggle" "arrow prev"]; }
            { on = "o"; run = "open --hovered"; desc = "Open hovered"; }
            { on = "O"; run = "open --hovered --interactive"; desc = "Open hovered interactively"; }
            { on = ["<S-p>"]; run = ["enter" "paste" "leave"]; desc = "Paste into Folder"; }
            { on = ["g" "d"]; run = "cd ~/Downloads/"; desc = "cd Downloads"; }
            { on = ["g" "l"]; run = "shell --block lazygit"; desc = "Lazygit"; }
            { on = ["R"]; run = "rename --hovered --empty=stem --cursor=start"; desc = "Rename File"; }
          ];
        };
      };

      flavors = {
        inherit (pkgs.yaziFlavors)
        catppuccin-mocha catppuccin-latte;
      };

      theme.flavor = {
        dark = "catppuccin-mocha";
        light = "catppuccin-latte";
      };
    };
  }