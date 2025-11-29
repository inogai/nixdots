{
  config,
  lib,
  pkgs,
  ...
}: {
  programs.tmux = {
    enable = true;
    shell = lib.getExe pkgs.bash;
    plugins = with pkgs.tmuxPlugins; [
      sensible
    ];
    extraConfig = ''
      # Start Nushell as the default command in panes
      set -g default-command "nu"
    '';
  };
}
