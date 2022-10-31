{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  devCfg = config.modules.dev;
  cfg = devCfg.go;
in
{
  options.modules.dev.go = {
    enable = mkBoolOpt false;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = with pkgs; [
        go
        gotools
        gopls
        go-outline
        gocode
        gopkgs
        gocode-gomod
        godef
        golint
      ];
      environment.variables.GOPRIVATE = "dev.azure.com/pentlandfirth/WhizCart";
    })
  ];
}
