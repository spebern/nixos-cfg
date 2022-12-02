{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.solidity;
in
{
  options.modules.dev.solidity = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        solc
      ];
    })
  ];
}
