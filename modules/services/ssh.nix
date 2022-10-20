{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.ssh;
in {
  options.modules.services.ssh = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.openssh = {
      enable = true;
      kbdInteractiveAuthentication = false;
      passwordAuthentication = false;
      allowSFTP = true;
      extraConfig = ''
        HostKeyAlgorithms +ssh-rsa
      '';
    };

    user.openssh.authorizedKeys.keys =
      if config.user.name == "bold"
      then [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC5p8LEihMKI0nqasuMz9Ip92+8y/H6S3vGc13UpBosI bernhard@specht.net" ]
      else [];
  };
}
