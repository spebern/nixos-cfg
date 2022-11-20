{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.grimshot;
in
{
  options.modules.desktop.apps.grimshot = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      sway-contrib.grimshot
    ];
  };
}
