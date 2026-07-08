{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.modules.zellij;

  # config.kdl is a template using @cmdMod@ / @optMod@ placeholders:
  #   @cmdMod@ -> the "command" modifier (Super on mac, Alt on windows)
  #   @optMod@ -> the "option" modifier  (Alt on mac, Super on windows)
  template = builtins.readFile ./config.kdl;

  modBindings =
    if cfg.keyLayout == "windows" then
      {
        cmdMod = "Alt";
        optMod = "Super";
      }
    else
      {
        cmdMod = "Super";
        optMod = "Alt";
      };

  configFile =
    builtins.replaceStrings
      [
        "@cmdMod@"
        "@optMod@"
      ]
      [
        modBindings.cmdMod
        modBindings.optMod
      ]
      template;
in
{
  options.my.modules.zellij = {
    enable = lib.mkEnableOption "zellij terminal workspace";

    keyLayout = lib.mkOption {
      type = lib.types.enum [
        "mac"
        "windows"
      ];
      default = "mac";
      description = ''
        Key modifier layout to use for keybindings.
        - `mac`: Super = Cmd, Alt = Option
        - `windows`: Alt = Cmd, Win (Super) = Option
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ zellij ];

    xdg.configFile."zellij/config.kdl".text = configFile;
  };
}