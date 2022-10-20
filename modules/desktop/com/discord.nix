{ config, options, lib, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.desktop.com.discord;
in {
  options.modules.desktop.com.discord = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nixpkgs.overlays = [
      (self: super: {
        discord = super.discord.overrideAttrs (
          _: { src = builtins.fetchTarball {
            url = "https://discord.com/api/download?platform=linux&format=tar.gz";
            sha256 = "0qaczvp79b4gzzafgc5ynp6h4nd2ppvndmj6pcs1zys3c0hrabpv";
          };}
        );
      })
    ];

    user.packages = with pkgs; [
      discord
    ];
  };
}

