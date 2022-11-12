{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.apps.dbeaver;
  wrapped = pkgs.writeShellScriptBin "dbeaver" ''
    GDK_BACKEND=x11 exec ${pkgs.dbeaver}/bin/dbeaver
  '';
in
{
  options.modules.desktop.apps.dbeaver = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      wrapped
      pkgs.dbeaver
    ];
  };
}
