{ options, config, lib, home-manager, pkgs, ... }:

with lib;
with lib.my;
let
  cfg = config.modules.services.gnome-keyring;
  configDir = config.dotfiles.configDir;
in
{
  options.modules.services.gnome-keyring = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    # https://github.com/NixOS/nixpkgs/issues/201324
    nixpkgs.overlays = [
      (
        final: prev: {
          gnome = prev.gnome // {
            gnome-keyring = (prev.gnome.gnome-keyring.override {
              glib = prev.glib.overrideAttrs (a: rec {
                patches = a.patches ++ [
                  (final.fetchpatch {
                    url =
                      "https://gitlab.gnome.org/GNOME/glib/-/commit/2a36bb4b7e46f9ac043561c61f9a790786a5440c.patch";
                    sha256 = "b77Hxt6WiLxIGqgAj9ZubzPWrWmorcUOEe/dp01BcXA=";
                  })
                ];
              });
            });
          };
        }
      )
    ];

    home-manager.users.${config.user.name} = {
      services.gnome-keyring = {
        enable = true;
        components = [ "pkcs11" "secrets" "ssh" ];
      };
    };

    security.pam.services.greetd.enableGnomeKeyring = true;
    security.pam.services.sddm.enableGnomeKeyring = true;

    environment.sessionVariables.SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
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
