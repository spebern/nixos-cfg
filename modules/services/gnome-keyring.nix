{ options, config, lib, home-manager, pkgs, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.gnome-keyring;
    configDir = config.dotfiles.configDir;
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
    security.pam.services.sddm.enableGnomeKeyring = true;

    user.packages = with pkgs; [
      gnome.seahorse
    ];

    home.configFile = {
      "zsh/gnome-keyring.zshrc".text = ''
        export SSH_AUTH_SOCK=/run/user/$UID/keyring/ssh
      '';
    };

    modules.shell.zsh.rcFiles = [ "${configDir}/gnome-keyring/default.zsh" ];
  };
}
