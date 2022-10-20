{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.com.slack;
in {
  options.modules.desktop.com.slack = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    environment.sessionVariables.NIXOS_OZONE_WL = "1";

    user.packages = with pkgs; [
      slack
    ];
  };
}

