{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.yml;
in
{
  options.modules.dev.yml = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        nodePackages.yaml-language-server
      ];
    })
  ];
}
