{ pkgs, config, lib, ... }:
{
  imports = [
    ../home.nix
    ./hardware-configuration.nix
  ];

  nixpkgs.config.allowUnfree = true;

  boot.loader.systemd-boot.enable = false;
  boot.loader.grub = {
    enable = true;
    version = 2;
    efiSupport = true;
    enableCryptodisk = true;
    device = "nodev";
  };

  boot.initrd.luks.devices = {
    crypted = {
      device = "/dev/disk/by-uuid/0be6788d-7d13-4bdf-8bb7-e2d520459713";
      preLVM = true;
    };
  };

  modules = {
    desktop = {
      sway = {
        enable = true;
      };
      i3.enable = true;
      apps = {
        waybar.enable = true;
        bitwarden.enable = true;
        flameshot.enable = true;
        zotero.enable = true;
        ticktick.enable = true;
        dbeaver.enable = true;
        grimshot.enable = true;
        libreoffice.enable = true;
        postman.enable = true;
      };
      com = {
        discord.enable = true;
        teams.enable = true;
        evolution.enable = true;
      };
      browsers = {
        default = "google-chrome";
        google-chrome.enable = true;
        firefox.enable = true;
      };
      media = {
        spotify.enable = true;
      };
      term = {
        default = "alacritty";
        alacritty.enable = true;
      };
      vm = {
        qemu.enable = true;
        virt-manager.enable = true;
      };
      gaming = {
        steam.enable = true;
      };
    };
    dev = {
      node.enable = true;
      rust.enable = true;
      cc.enable = true;
      nix.enable = true;
      go.enable = true;
      python.enable = true;
      latex.enable = true;
      json.enable = true;
      yml.enable = true;
      solidity.enable = true;
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
      nextcloud.enable = true;
      blueman.enable = true;
      mlocate.enable = true;
      gnome-keyring.enable = true;
      flatpak.enable = true;
    };
    hardware = {
      wifi.enable = true;
      wifi.iwd.enable = false;
      fs = {
        enable = true;
        ntfs.enable = true;
      };
      bluetooth.enable = true;
    };
    network = {
      openvpn.enable = true;
    };
    theme.active = "alucard";
    misc = {
      scowl.enable = true;
      hugo.enable = true;
    };
  };

  services = {
    tlp.enable = true;
    openssh.startWhenNeeded = true;
  };

  networking.networkmanager.enable = true;
  powerManagement.powertop.enable = true;

  boot.initrd.kernelModules = [ "amdgpu" ];
  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.opengl = {
    driSupport = true;
    driSupport32Bit = true;
  };
  boot.extraModprobeConfig = ''
    options iwlmvm power_scheme=1
    options iwlwifi power_save=0
  '';
  services.xserver = {
    enable = true;
    displayManager = {
      sddm.enable = true;
      defaultSession = "sway";
    };
  };
}
