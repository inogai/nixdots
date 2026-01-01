{
  config,
  pkgs,
  ...
}: {
  programs.yazi = {
    enable = true;
    enableNushellIntegration = true;

    initLua = ./init.lua;

    settings = {
      mgr = {
        sort_by = "mtime";
        sort_reverse = true;
        linemode = "mtime";
      };
    };

    keymap = {
      mgr = {
        prepend_keymap = [
          {
            on = ["<C-x>" "<Space>"];
            run = ["toggle" "arrow prev"];
          }
          {
            on = "o";
            run = "open --hovered";
            desc = "Open hovered";
          }
          {
            on = "O";
            run = "open --hovered --interactive";
            desc = "Open hovered interactively";
          }
          {
            on = ["<S-p>"];
            run = ["enter" "paste" "leave"];
            desc = "Paste into Folder";
          }
          {
            on = ["g" "d"];
            run = "cd ~/Downloads/";
            desc = "cd Downloads";
          }
          {
            on = ["g" "l"];
            run = "shell --block lazygit";
            desc = "Lazygit";
          }
          {
            on = ["R"];
            run = "rename --hovered --empty=stem --cursor=start";
            desc = "Rename File";
          }
        ];
      };
    };

    flavors = {
      inherit
        (pkgs.yaziFlavors)
        catppuccin-mocha
        catppuccin-latte
        ;
    };

    theme.flavor = {
      dark = "catppuccin-mocha";
      light = "catppuccin-latte";
    };
  };
}
