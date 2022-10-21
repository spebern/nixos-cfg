{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.i3;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.i3 = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    modules.theme.onReload.i3 = ''
      ${pkgs.i3}/bin/i3-msg reload
      ${pkgs.i3}/bin/i3-msg restart
    '';

    environment.systemPackages = with pkgs; [
      lightdm
      dunst
      libnotify
      i3lock
      rofi
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
    ];

    services = {
      picom.enable = true;
      redshift.enable = true;
      xserver.windowManager.i3.enable = true;
    };

    systemd.user.services."dunst" = {
      enable = true;
      description = "";
      wantedBy = [ "default.target" ];
      serviceConfig.Restart = "always";
      serviceConfig.RestartSec = 2;
      serviceConfig.ExecStart = "${pkgs.dunst}/bin/dunst";
    };

    # link recursively so other modules can link files in their folders
    home.configFile = {
      "sxhkd".source = "${configDir}/sxhkd";
      "i3" = {
        source = "${configDir}/i3";
        recursive = true;
      };
    };
  };
}
