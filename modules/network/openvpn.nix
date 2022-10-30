{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.network.openvpn;
in {
  options.modules.network.openvpn = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      openvpn
      networkmanager-openvpn
    ];
    user.extraGroups = [ "networkmanager" ];
  };
}
