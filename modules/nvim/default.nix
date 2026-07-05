{
  config,
  pkgs,
  lib,
  ...
}:
let
  cfg = config.my.modules.nvim;
  extraPackages = with pkgs; [
    nodejs
    nixfmt
    nil
  ];
in
{
  options.my.modules.nvim.enable = lib.mkEnableOption "neovim text editor";

  config = lib.mkIf cfg.enable {
    xdg.configFile."nvim-lazy".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/home-manager/modules/nvim/nvim-lazy/";

    home.packages = with pkgs; [
      (pkgs.symlinkJoin {
        name = "nvim-lazy";
        paths = [ pkgs.neovim ];
        buildInputs = [ pkgs.makeWrapper ];
        postBuild = ''
          wrapProgram $out/bin/nvim \
          --set NVIM_APPNAME "nvim-lazy" \
          --prefix PATH : ${pkgs.lib.makeBinPath extraPackages}
        '';
      })
    ];
  };
}
