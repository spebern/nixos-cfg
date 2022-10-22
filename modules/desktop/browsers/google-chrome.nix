{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.google-chrome;
in {
  options.modules.desktop.browsers.google-chrome = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      google-chrome
      (makeDesktopItem {
        name = "google-chrome";
        desktopName = "Google Chrome";
        icon = "chrome";
        exec = "${pkgs.google-chrome}/bin/google-chrome-stable";
        categories = [ "Network" ];
      })
    ];
  };
}
