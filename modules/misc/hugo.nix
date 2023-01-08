{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.misc.hugo;
in
{
  options.modules.misc.hugo = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = [
      pkgs.hugo
    ];
    environment.wordlist.enable = true;
  };
}
