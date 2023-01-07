{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.hardware.wifi;
in
{
  options.modules.hardware.wifi = {
    enable = mkBoolOpt false;
    iwd.enable = mkBoolOpt true;
  };

  config = mkIf cfg.enable {
    networking =
      if cfg.iwd.enable then
        {
          networkmanager.wifi.backend = "iwd";
          wireless.iwd = {
            enable = true;
            settings = {
              General = {
                ControlPortOverNL80211 = false;
              };
            };
          };
        } else
        { };
  };
}
