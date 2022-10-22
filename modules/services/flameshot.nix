{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.flameshot;
in {
  options.modules.services.flameshot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.flameshot = {
    settings = {
      General = {
        savePath = "/home/${user}/";
        saveAsFileExtension = ".png";
        uiColor = "#2d0096";
        showHelp = "false";
        disabledTrayIcon = "true";
        useJpgForClipboard = "true";
      };
    };
  };
}
