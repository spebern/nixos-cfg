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
            sha256 = "1pw9q4290yn62xisbkc7a7ckb1sa5acp91plp2mfpg7gp7v60zvz";
          };}
        );
      })
    ];

    user.packages = with pkgs; [
      discord
    ];
  };
}

