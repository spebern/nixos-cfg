{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    <nixos-hardware/lenovo/thinkpad/p50>
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  modules = {
    desktop = {
      sway = {
        enable = true;
        scale = "2.0";
      };
      i3.enable = true;
      apps = {
        waybar.enable = true;
        bitwarden.enable = true;
      };
      com = {
        discord.enable = true;
        teams.enable = true;
      };
      browsers = {
        default = "google-chrome";
        google-chrome.enable = true;
        firefox.enable = true;
      };
      media = {
        documents.enable = true;
        recording.enable = true;
        spotify.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      vm = {
        qemu.enable = true;
      };
    };
    dev = {
      node.enable = true;
      rust.enable = true;
      cc.enable = true;
      nix.enable = true;
      # python.enable = true;
    };
    editors = {
      default = "nvim";
      emacs = {
        enable = true;
        doom.enable = true;
      };
      vim.enable = true;
    };
    shell = {
      direnv.enable = true;
      git.enable = true;
      gnupg.enable = true;
      zsh.enable = true;
    };
    services = {
      ssh.enable = true;
      docker.enable = true;
      onedrive.enable = true;
      blueman.enable = true;
      mlocate.enable = true;
    };
    hardware = {
      wifi.enable = true;
    };
    theme.active = "alucard";
  };

  services = {
    xserver = {
      enable = true;
      displayManager = {
        sddm = {
          enable = true;
        };
        defaultSession = "sway";
      };
      videoDrivers = [
        "nouveau"
        "intel"
      ];
    };
    logind = {
      lidSwitch = "hibernate";
      lidSwitchDocked = "hibernate";
      lidSwitchExternalPower = "hibernate";
    };
    tlp = {
      enable = true;
      settings = {
        WIFI_PWR_ON_AC = "off";
        WIFI_PWR_ON_BAT = "off";
      };
    };
    openssh.startWhenNeeded = true;
  };

  programs.ssh.startAgent = true;
  networking.networkmanager.enable = true;
  powerManagement.powertop.enable = true;
}
