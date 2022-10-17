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
      swaylock
      rofi
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

    # programs.sway = {
    #   enable = true;
    #   wrapperFeatures.gtk = true;
    # };

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
        ];

        bars = [];

        fonts = {
          names = [ "Source Code Pro" ];
          size = 10.0;
        };

        # output = {
        #   "*".scale = "1";
        # };

        colors.focused = {
          background = "#999999";
          border = "#999999";
          childBorder = "#999999";
          indicator = "#212121";
          text = "#999999";
        };

        keybindings = {                                   # Hotkeys
          "${modifier}+Escape" = "exec swaymsg exit";     # Exit Sway
          "${modifier}+Return" = "exec ${terminal}";      # Open terminal
          "${modifier}+space" = "exec ${menu}";           # Open menu
          "${modifier}+e" = "exec ${pkgs.pcmanfm}/bin/pcmanfm"; # File Manager
          "Control+Shift+l" = "exec ${pkgs.swaylock-fancy}/bin/swaylock-fancy"; # Lock Screen

          "${modifier}+r" = "reload";                     # Reload environment
          "${modifier}+Shift+q" = "kill";                       # Kill container
          "${modifier}+f" = "fullscreen toggle";          # Fullscreen

          "${modifier}+h" = "focus left";
          "${modifier}+l" = "focus right";
          "${modifier}+j" = "focus up";
          "${modifier}+k" = "focus down";

          "${modifier}+Shift+h" = "move left";
          "${modifier}+Shift+l" = "move right";
          "${modifier}+Shift+j" = "move up";
          "${modifier}+Shift+k" = "move down";

          "${modifier}+1" = "workspace number 1";
          "${modifier}+2" = "workspace number 2";
          "${modifier}+3" = "workspace number 3";
          "${modifier}+4" = "workspace number 4";
          "${modifier}+5" = "workspace number 5";
          "${modifier}+6" = "workspace number 6";
          "${modifier}+7" = "workspace number 7";
          "${modifier}+8" = "workspace number 8";
          "${modifier}+9" = "workspace number 9";
          "${modifier}+0" = "workspace number 0";

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
          "${modifier}+Shift+0" = "move container to workspace number 0";

          "Control+Up" = "resize shrink height 20px";
          "Control+Down" = "resize grow height 20px";
          "Control+Left" = "resize shrink width 20px";
          "Control+Right" = "resize grow width 20px";
        };
      };
      extraSessionCommands = ''
      #export WLR_NO_HARDWARE_CURSORS="1";  # Needed for cursor in vm
      export XDG_SESSION_TYPE=wayland
      export XDG_SESSION_DESKTOP=sway
      export XDG_CURRENT_DESKTOP=sway
      '';
    };
  };
}
