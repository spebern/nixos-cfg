{ options, config, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.gaming.lutris;
in
{
  options.modules.desktop.gaming.lutris = with types;{
    enable = mkBoolOpt false; # Playstation
  };

  config = {
    user.packages = with pkgs; [
      lutris
    ];
  };
}
