{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.blueman;
in {
  options.modules.services.blueman = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.blueman = {
      enable = true;
    };
  };
}
