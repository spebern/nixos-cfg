{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.ticktick;
in
{
  options.modules.desktop.apps.ticktick = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      my.ticktick
    ];
  };
}
