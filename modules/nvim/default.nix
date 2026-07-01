{
  config,
  pkgs,
  lib,
  ...
}:
let
  extraPackages = with pkgs; [
    nodejs
    nixfmt
    nil
  ];
in
{
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
}
