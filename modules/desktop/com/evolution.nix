{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.com.evolution;
in {
  options.modules.desktop.com.evolution = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      evolution
      evolution-ews
    ];
  };
}
