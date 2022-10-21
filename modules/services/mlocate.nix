{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.mlocate;
in {
  options.modules.services.mlocate = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.locate = {
      enable = true;
      locate = pkgs.mlocate;
      interval = "hourly";
    };
    user.extraGroups = [ "mlocate" ];
  };
}
