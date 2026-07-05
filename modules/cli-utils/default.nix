{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.cli-utils;

  fzfOptions = [
    "--prompt=❯"
    "--gutter=' ' "
    "--color=bg:-1,bg+:-1"
    "--color=hl:#d8a657,hl+:#d8a657:reverse"
    "--color=fg:#ebdbb2,fg+:#ebdbb2:reverse"
    "--color=header:#83a598"
    "--color=spinner:#8ec07c"
    "--color=marker:#8ec07c,header:#83a598"
    "--color=prompt:#89b482,pointer:#83a598"
    "--color=info:#a89984,separator:#a89984"
    "--color=query:#ebdbb2:regular"
  ];
in
{
  options.my.modules.cli-utils.enable = lib.mkEnableOption "CLI utilities";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      git
      gnupg
      wget
      curl
      fd
      ripgrep
      github-cli
      trash-cli
      p7zip

      gnutar
      zstd

      coreutils
      jq
      yq-go
      util-linux
      socat

      pandoc

      deno

      nix-prefetch-git

      wakatime-cli

      (writeShellScriptBin "noti" (builtins.readFile ./noti))

      (writeShellScriptBin "md2pdf" ''
        exec ${./md2pdf.ts} "$@"
      '')

      (writeShellScriptBin "fzf" ''
        export FZF_DEFAULT_OPTS="${lib.concatStringsSep " " fzfOptions}"
        exec ${pkgs.fzf}/bin/fzf "$@"
      '')
    ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks."*" = {
        addKeysToAgent = "12h";
        forwardAgent = true;
      };
    };
    services.ssh-agent = {
      enable = true;
      defaultMaximumIdentityLifetime = 3600;
    };

    programs.ripgrep-all = {
      enable = true;
    };
  };
}
