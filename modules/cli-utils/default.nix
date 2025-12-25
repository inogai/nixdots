{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    git
    gnupg
    # openssh # use system ssh
    wget
    curl
    fd
    ripgrep
    fzf
    github-cli
    trash-cli

    jq
    yq-go
    util-linux

    uv
    deno

    nix-prefetch-git

    wakatime-cli

    (writeShellScriptBin "md2pdf" ''
      exec ${./md2pdf.ts} "$@"
    '')
  ];
}
