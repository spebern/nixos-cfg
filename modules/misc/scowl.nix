{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.misc.scowl;
in
{
  options.modules.misc.scowl = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.scowl
    ];
    environment.wordlist.enable = true;
  };
}
