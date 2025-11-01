{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    lua54Packages.lua
    lua54Packages.penlight
    lua54Packages.inspect
    sketchybar
    sketchybar-app-font
    sbarlua
    jq
  ];

  home.file.".config/sketchybar" = {
    source = ./config;
    recursive = true;
  };

  home.file.".config/sketchybar/sketchybarrc" = {
    text = ''
      #!/usr/bin/env lua
      package.path = package.path .. ";${config.home.homeDirectory}/.config/sketchybar/?.lua;${pkgs.lua54Packages.penlight}/share/lua/5.4/?.lua;${pkgs.lua54Packages.inspect}/share/lua/5.4/?.lua"
      package.cpath = package.cpath .. ";" .. "${pkgs.sbarlua}/lib/lua/5.4/?.so"
      require("helpers")
      require("init")
    '';
    executable = true;
  };
}