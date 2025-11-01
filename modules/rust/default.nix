{ config, pkgs, fenix, ... }:

{
  home.packages = [
    fenix.packages.${pkgs.system}.complete.toolchain
  ];
}