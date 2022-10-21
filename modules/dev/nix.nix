{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let devCfg = config.modules.dev;
    cfg = devCfg.nix;
in {
  options.modules.dev.nix = {
    enable = mkBoolOpt false;
    xdg.enable = mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      user.packages = [
        pkgs.unstable.rnix-lsp
      ];
    })

    (mkIf cfg.xdg.enable {})
  ];
}
