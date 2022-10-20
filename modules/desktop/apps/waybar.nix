{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.apps.waybar;

in {
  options.modules.desktop.apps.waybar = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      waybar
    ];

    home-manager.users.${config.user.name}.programs.waybar = {
      enable = true;
      systemd ={
        enable = true;
        target = "sway-session.target";
      };

      style = ''
        * {
          border: none;
          font-family: FiraCode Nerd Font Mono;
          color: #ffffff;
        }
        window#waybar {
          background-color: rgba(0,0,0,0.0);
          transition-property: background-color;
          transition-duration: .20s;
          border-bottom: none;
        }
        #workspace,
        #mode,
        #clock,
        #pulseaudio,
        #network,
        #mpd,
        #memory,
        #network,
        #window,
        #cpu,
        #disk,
        #battery,
        #tray {
          color: #ffffff;
          margin: 2px 16px 2px 16px;
          background-clip: padding-box;
        }
        #workspaces button {
          padding: 0 5px;
          min-width: 15px;
        }
        #workspaces button:hover {
          background-color: rgb(0,152,208);
        }
        #workspaces button.focused {
          color: rgb(0,152,208);
        }
        #battery.warning {
          color: #ff5d17;
        }
        #battery.critical {
          color: #ff200c;
        }
        #battery.charging {
          color: #9ece6a;
        }
      '';
      settings = [{
        layer = "top";
        position = "top";
        height = 16;
        output = [
          "eDP-1"
        ];
        tray = { spacing = 10; };
        modules-center = [ "clock" ];
        modules-left = [ "sway/workspaces" "sway/mode" ];
        #modules-left = [ "wlr/workspaces" ];
        modules-right = [ "cpu" "memory" "disk" "pulseaudio" "battery" "tray" ];
        #modules-right = [ "cpu" "memory" "pulseaudio" "clock" "tray" ];

        "sway/workspaces" = {
          format = "<span font='12'>{icon}</span>";
          all-outputs = true;
        };
        "wlr/workspaces" = {
          format = "<span font='12'>{icon}</span>";
          all-outputs = true;
          active-only = false;
          on-click = "activate";
        };
        clock = {
          format = "{:%b %d %H:%M}";
          tooltip-format = "<big>{:%Y %B}</big>\n<tt><small>{calendar}</small></tt>";
          format-alt = "{:%A, %B %d, %Y} ";
        };
        cpu = {
          format = "{usage}% <span font='11'></span>";
          tooltip = false;
          interval = 1;
        };
        disk = {
          format = "{percentage_used}% <span font='11'></span>";
          path = "/";
          interval = 30;
        };
        memory = {
          format = "{}% <span font='11'></span>";
          interval = 1;
        };
        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{capacity}% <span font='11'>{icon}</span>";
          format-charging = "{capacity}% <span font='11'></span>";
          format-icons = ["" "" "" "" ""];
          max-length = 25;
        };
        pulseaudio = {
          format = "<span font='11'>{icon}</span> {volume}% {format_source}";
          format-bluetooth = "<span font='11'>{icon}</span> {volume}% {format_source}";
          format-bluetooth-muted = "<span font='11'></span> {volume}% {format_source}";
          format-muted = "<span font='11'></span> {format_source}";
          #format-source = "{volume}% <span font='11'></span>";
          format-source = "<span font='11'></span>";
          format-source-muted = "<span font='11'></span>";
          format-icons = {
            default = [ "" "" "" ];
            headphone = "";
            #hands-free = "";
            #headset = "";
            #phone = "";
            #portable = "";
            #car = "";
          };
          tooltip-format = "{desc}, {volume}%";
          on-click = "${pkgs.pamixer}/bin/pamixer -t";
          on-click-right = "${pkgs.pamixer}/bin/pamixer --default-source -t";
          on-click-middle = "${pkgs.pavucontrol}/bin/pavucontrol";
        };
        tray = {
          icon-size = 11;
        };
      }];
    };
  };
}
