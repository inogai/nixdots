{
  config,
  pkgs,
  nix-colors,
  ...
}: {
  imports = [
    nix-colors.homeManagerModules.default
    ./modules/aerospace
    ./modules/sketchybar
    ./modules/kitty
    ./modules/shell
    ./modules/fzfmenu
    ./modules/qutebrowser
    ./modules/opencode
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
  home.stateVersion = "25.05"; # Please read the comment before changing.

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

    lazygit
    jq

    uv

    nix-prefetch-git

    jetbrains-mono
    victor-mono
    ibm-plex
    nerd-fonts.symbols-only

    nur.repos.inogai.winterm-rs
    nvim-inogai

    wakatime-cli
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/inogai/etc/profile.d/hm-session-vars.sh
  #

  programs.home-manager.enable = true;
}
