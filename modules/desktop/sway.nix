{ options, config, lib, pkgs, home-manager, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.desktop.sway;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.desktop.sway = {
    enable = mkBoolOpt false;
    scale = mkOpt types.str "1.5";
  };

  config = mkIf cfg.enable {
    modules.theme.onReload.sway = ''
      ${pkgs.sway}/bin/sway-msg reload
      ${pkgs.sway}/bin/sway-msg restart
    '';

    user.packages = with pkgs; [
      sway
      autotiling
      swayidle
      alacritty
      wayland
      glib
      grim
      wl-clipboard
      xwayland
      wayvnc
      dunst
      libnotify
      swaylock
      wofi
      kanshi
      networkmanagerapplet
      blueman
      swayr
      wdisplays
    ];

    services = {
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
      dbus = {
        enable = true;
      };
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };


    xdg.portal = {
      enable = true;
      wlr.enable = true;
      # gtk portal needed to make gtk apps happy
      extraPortals = [
        pkgs.xdg-desktop-portal-wlr
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
        pkgs.xdg-desktop-portal-kde
      ];
      # gtkUsePortal = true;
    };

    home-manager.users.${config.user.name} = {
      programs = {
        swaylock.settings = {
          color = "000000";
          font-size = 24;
          indicator-idle-visible = false;
          indicator-radius = 100;
          line-color = "ffffff";
          show-failed-attempts = true;
        };
      };
      services = {
        swayidle = {
          enable = true;
          events = [
            { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock"; }
            { event = "lock"; command = "lock"; }
          ];
        };
        kanshi = {
          enable = true;
          profiles = {
            lonely = {
              outputs = [
                {
                  criteria = "eDP-1";
                  mode = "2880x1800@90.000Hz";
                  scale = 1.5;
                }
              ];
            };
            sharmin = {
              outputs = [
                {
                  criteria = "Lenovo Group Limited P27h-20 V906YMAV";
                  mode = "2560x1440@59.951Hz";
                  position = "0,0";
                  scale = 1.0;
                }
                {
                  criteria = "eDP-1";
                  mode = "2880x1800@90.000Hz";
                  position = "2560,0";
                  scale = 1.5;
                }
              ];
            };
          };
        };
      };
      wayland.windowManager.sway = {
        enable = true;
        systemdIntegration = true;
        xwayland = true;
        wrapperFeatures = {
          gtk = true;
        };
        config = rec {
          modifier = "Mod4";
          terminal = "${pkgs.alacritty}/bin/alacritty";
          menu = "${pkgs.wofi}/bin/wofi --show drun -i";

          startup = [
            { command = "${pkgs.autotiling}/bin/autotiling"; always = true; }
            { command = "systemctl --user restart waybar"; always = true; }
            {
              command = ''
                ${pkgs.swayidle}/bin/swayidle -w \
                 before-sleep '${pkgs.swaylock}/bin/swaylock'
              '';
              always = true;
            }
            { command = "${pkgs.blueman}/bin/blueman-applet"; always = true; }
            { command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; always = true; }
            { command = "${pkgs.swayr}/bin/swayrd"; always = true; }
          ];

          bars = [ ];

          fonts = {
            names = [ "Source Code Pro" ];
            size = 10.0;
          };

          gaps = {
            smartBorders = "on";
            outer = 0;
          };

          workspaceAutoBackAndForth = true;
          window.hideEdgeBorders = "smart";

          input = {
            "type:touchpad" = {
              tap = "disabled";
              dwt = "enabled";
              scroll_method = "two_finger";
              middle_emulation = "enabled";
              natural_scroll = "enabled";
            };
            "type:keyboard" = {
              xkb_layout = "us";
              xkb_numlock = "enabled";
            };
          };

          output = {
            "*".scale = cfg.scale;
          };

          colors.focused = {
            background = "#000000";
            border = "#999999";
            childBorder = "#999999";
            indicator = "#212121";
            text = "#999999";
          };

          keybindings = {
            # Hotkeys
            "${modifier}+Escape" = "exec swaymsg exit"; # Exit Sway
            "${modifier}+Return" = "exec ${terminal}"; # Open terminal
            "${modifier}+d" = "exec ${menu}"; # Open menu
            "Control+Shift+l" = "exec ${pkgs.swaylock}/bin/swaylock"; # Lock Screen

            "${modifier}+r" = "reload"; # Reload environment
            "${modifier}+Shift+q" = "kill"; # Kill container
            "${modifier}+f" = "fullscreen toggle"; # Fullscreen

            "${modifier}+h" = "focus left";
            "${modifier}+l" = "focus right";
            "${modifier}+k" = "focus up";
            "${modifier}+j" = "focus down";

            "${modifier}+Shift+h" = "move left";
            "${modifier}+Shift+l" = "move right";
            "${modifier}+Shift+k" = "move up";
            "${modifier}+Shift+j" = "move down";

            "${modifier}+1" = "workspace number 1";
            "${modifier}+2" = "workspace number 2";
            "${modifier}+3" = "workspace number 3";
            "${modifier}+4" = "workspace number 4";
            "${modifier}+5" = "workspace number 5";
            "${modifier}+6" = "workspace number 6";
            "${modifier}+7" = "workspace number 7";
            "${modifier}+8" = "workspace number 8";
            "${modifier}+9" = "workspace number 9";
            "${modifier}+0" = "workspace number 10";

            "Alt+Shift+Left" = "move container to workspace prev, workspace prev"; # Move container to next available workspace and focus
            "Alt+Shift+Right" = "move container to workspace next, workspace next";

            "${modifier}+Shift+1" = "move container to workspace number 1";
            "${modifier}+Shift+2" = "move container to workspace number 2";
            "${modifier}+Shift+3" = "move container to workspace number 3";
            "${modifier}+Shift+4" = "move container to workspace number 4";
            "${modifier}+Shift+5" = "move container to workspace number 5";
            "${modifier}+Shift+6" = "move container to workspace number 6";
            "${modifier}+Shift+7" = "move container to workspace number 7";
            "${modifier}+Shift+8" = "move container to workspace number 8";
            "${modifier}+Shift+9" = "move container to workspace number 9";
            "${modifier}+Shift+0" = "move container to workspace number 10";

            "${modifier}+Control+Shift+H" = "move workspace to output left";
            "${modifier}+Control+Shift+L" = "move workspace to output right";
            "${modifier}+Control+Shift+K" = "move workspace to output up";
            "${modifier}+Control+Shift+J" = "move workspace to output down";

            "Control+Up" = "resize shrink height 20px";
            "Control+Down" = "resize grow height 20px";
            "Control+Left" = "resize shrink width 20px";
            "Control+Right" = "resize grow width 20px";

            "${modifier}+s" = "layout stacking";
            "${modifier}+w" = "layout tabbed";
            "${modifier}+e" = "layout toggle split";

            "${modifier}+b" = "splith";
            "${modifier}+v" = "splitv";

            "${modifier}+Space" = "exec ${pkgs.swayr}/bin/swayr switch-window";
            "${modifier}+Tab" = "exec ${pkgs.swayr}/bin/swayr switch-to-urgent-or-lru-window";
            "${modifier}+Next" = "exec ${pkgs.swayr}/bin/swayr next-window";
            "${modifier}+Prior" = "exec ${pkgs.swayr}/bin/swayr prev-window";
          };
        };

        extraConfig = ''
          for_window [app_id="pcmanfm"] floating enable
          for_window [app_id="pavucontrol"] floating enable, sticky
          for_window [app_id=".blueman-manager-wrapped"] floating enable
          for_window [title="Picture in picture"] floating enable, move p>
        '';

        extraSessionCommands = ''
          #export WLR_NO_HARDWARE_CURSORS="1";  # Needed for cursor in vm
          export XDG_SESSION_TYPE=wayland
          export XDG_SESSION_DESKTOP=sway
          export XDG_CURRENT_DESKTOP=sway
          export WLR_RENDERER=vulkan
        '';
      };
    };
  };
}
