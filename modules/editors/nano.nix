# When I'm stuck in the terminal and suffer all shiny editors I go for nano

{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.editors.nano;
in {
  options.modules.editors.nano = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
      nano
    ];
  };
}
