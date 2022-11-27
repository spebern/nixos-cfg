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
          "bip" = "172.39.1.5/24";
          "fixed-cidr" = "172.39.1.0/25";
        };
      };
    };
  };
}
