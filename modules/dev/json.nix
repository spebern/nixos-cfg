{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.json;
in
{
  options.modules.dev.json = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        nodePackages.vscode-json-languageserver
      ];
    })
  ];
}
