{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.docker;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.services.docker = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      docker
      docker-compose
    ];

    env.DOCKER_CONFIG = "$XDG_CONFIG_HOME/docker";
    env.MACHINE_STORAGE_PATH = "$XDG_DATA_HOME/docker/machine";

    user.extraGroups = [ "docker" ];

    modules.shell.zsh.rcFiles = [ "${configDir}/docker/aliases.zsh" ];

    virtualisation = {
      docker = {
        enable = true;
        autoPrune.enable = true;
        enableOnBoot = mkDefault false;
        daemon.settings = {
          "bip" = "10.200.0.1/24";
          "default-address-pools" = [
            {
              "base" = "10.201.0.0/16";
              "size" = 24;
            }
            {
              "base" = "10.202.0.0/16";
              "size" = 24;
            }
          ];
        };
      };
    };
  };
}
