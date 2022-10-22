{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.browsers;
  desktopItem = cfg.default + ".desktop";
in
{
  options.modules.desktop.browsers = {
    default = mkOpt (with types; nullOr str) null;
  };

  config = mkIf (cfg.default != null) {
    env.BROWSER = cfg.default;

    xdg.mime.enable = true;
    xdg.mime.defaultApplications = {
      "text/html" = desktopItem;
      "x-scheme-handler/http" = desktopItem;
      "x-scheme-handler/https" = desktopItem;
      "x-scheme-handler/about" = desktopItem;
      "x-scheme-handler/unknown" = desktopItem;
    };
  };
}
