{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.browsers.chrome;
in {
  options.modules.desktop.browsers.chrome = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      google-chrome
      (makeDesktopItem {
        name = "google-chrome";
        desktopName = "Google Chrome";
        icon = "chrome";
        exec = "${google-chrome}/bin/google";
        categories = [ "Network" ];
      })
    ];
  };
}
