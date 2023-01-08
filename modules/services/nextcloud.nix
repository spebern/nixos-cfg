{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.nextcloud;
in
{
  options.modules.services.nextcloud = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nextcloud-client
    ];

    home-manager.users.${config.user.name}.services.nextcloud-client = {
      enable = true;
      startInBackground = false;
    };
  };
}
