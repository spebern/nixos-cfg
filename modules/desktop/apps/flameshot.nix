{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.flameshot;
in {
  options.modules.desktop.apps.flameshot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name}.services.flameshot = {
      enable = true;
    };
  };
}
