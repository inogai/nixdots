{
  config,
  lib,
  pkgs,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default
    ./modules/aerospace
    ./modules/kitty
    ./modules/shell
    ./modules/yazi
    ./modules/fzfmenu
    ./modules/qutebrowser
    ./modules/opencode
    ./modules/latex
    ./modules/docker
    ./modules/tmux
    ./modules/tui-apps
  ];

  colorScheme = import ./lib/colorscheme.nix;
  # colorScheme = nix-colors.colorSchemes.gruvbox-dark-medium;

  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "inogai";
  home.homeDirectory = "/Users/inogai";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
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

    jetbrains-mono
    victor-mono
    ibm-plex
    nerd-fonts.symbols-only
    lilex
    nerd-fonts.lilex

    nur.repos.inogai.winterm-rs
    nvim-inogai

    wakatime-cli

    inter

    prismlauncher
    bruno

    (writeShellScriptBin "md2pdf" ''
      exec ${./scripts/md2pdf.ts} "$@"
    '')
  ];

  home.file = {};

  news.display = "silent";

  programs.home-manager.enable = true;
  programs.hm-ricing-mode.enable = true;
}
