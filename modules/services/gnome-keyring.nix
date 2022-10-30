{ options, config, lib, home-manager, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.gnome-keyring;
in {
  options.modules.services.gnome-keyring = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home-manager.users.${config.user.name}.services.gnome-keyring = {
      enable = true;
      components = ["pkcs11" "secrets" "ssh"];
    };
    security.pam.services.greetd.enableGnomeKeyring = true;

    user.packages = with pkgs; [
      gnome.seahorse
    ];
  };
}
