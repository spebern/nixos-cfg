{ options, config, lib, pkgs, home-manager, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.sway;
    configDir = config.dotfiles.configDir;
in {
  options.modules.desktop.sway = {
    enable = mkBoolOpt false;
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
      swaylock-fancy
      rofi
      kanshi
      networkmanagerapplet
      blueman
      (polybar.override {
        pulseSupport = true;
        nlSupport = true;
      })
    ];

    services = {
      # greetd = {
      #   enable = true;
      #   settings = {
      #     default_session = {
      #       command = "${pkgs.sway}/bin/sway";
      #     };
      #   };
      # };
      pipewire = {
        enable = true;
        alsa.enable = true;
        pulse.enable = true;
      };
      # dbus = {
      #   enable = true;
      # };
    };

    programs.sway = {
      enable = true;
      wrapperFeatures.gtk = true;
    };

    xdg.portal = {
      enable = true;
      wlr.enable = true;
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
      ];
      # gtkUsePortal = true;
    };

    home-manager.users.${config.user.name}.wayland.windowManager.sway = {
      enable = true;
      systemdIntegration = true;
      config = rec {
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.rofi}/bin/rofi -show drun";

        startup = [
          {command = "${pkgs.autotiling}/bin/autotiling"; always = true;}
          {command = "systemctl --user restart waybar"; always = true; }
          {command = ''
             ${pkgs.swayidle}/bin/swayidle -w \
              before-sleep '${pkgs.swaylock-fancy}/bin/swaylock-fancy'
            ''; always = true;}
          {command = ''
            ${pkgs.swayidle}/bin/swayidle \
              timeout 120 '${pkgs.swaylock-fancy}/bin/swaylock-fancy' \
              timeout 240 'swaymsg "output * dpms off"' \
              resume 'swaymsg "output * dpms on"' \
              before-sleep '${pkgs.swaylock-fancy}/bin/swaylock-fancy'
            ''; always = true;}                            # Auto lock\
          {command = "${pkgs.blueman}/bin/blueman-applet"; always = true;}
          {command = "${pkgs.networkmanagerapplet}/bin/nm-applet --indicator"; always = true;}
        ];

        bars = [];

        fonts = {
          names = [ "Source Code Pro" ];
          size = 10.0;
        };

        gaps = {
          smartBorders = "on";
          outer = 0;
        };

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
          "*".scale = "1.5";
        };

        colors.focused = {
          background = "#000000";
          border = "#999999";
          childBorder = "#999999";
          indicator = "#212121";
          text = "#999999";
        };

        keybindings = {                                   # Hotkeys
          "${modifier}+Escape" = "exec swaymsg exit";     # Exit Sway
          "${modifier}+Return" = "exec ${terminal}";      # Open terminal
          "${modifier}+d" = "exec ${menu}";           # Open menu
          "${modifier}+e" = "exec ${pkgs.pcmanfm}/bin/pcmanfm"; # File Manager
          "Control+Shift+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy"; # Lock Screen

          "${modifier}+r" = "reload";                     # Reload environment
          "${modifier}+Shift+q" = "kill";                       # Kill container
          "${modifier}+f" = "fullscreen toggle";          # Fullscreen

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

          "Alt+Shift+Left" = "move container to workspace prev, workspace prev";    # Move container to next available workspace and focus
          "Alt+Shift+Right" = "move container to workspace next, workspace next";

          "${modifier}+Shift+1" = "move container to workspace number 1";
          "${modifier}+Shift+2" = "move container to workspace number 3";
          "${modifier}+Shift+4" = "move container to workspace number 4";
          "${modifier}+Shift+5" = "move container to workspace number 5";
          "${modifier}+Shift+6" = "move container to workspace number 6";
          "${modifier}+Shift+7" = "move container to workspace number 7";
          "${modifier}+Shift+8" = "move container to workspace number 8";
          "${modifier}+Shift+9" = "move container to workspace number 9";
          "${modifier}+Shift+0" = "move container to workspace number 10";

          "Control+Up" = "resize shrink height 20px";
          "Control+Down" = "resize grow height 20px";
          "Control+Left" = "resize shrink width 20px";
          "Control+Right" = "resize grow width 20px";
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
      '';
    };
  };
}
