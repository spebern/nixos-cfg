{ config, lib, ... }:

with builtins;
with lib;
let blocklist = fetchurl https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts;
in {
  networking.extraHosts = ''
    # Block garbage
    ${optionalString config.services.xserver.enable (readFile blocklist)}
  '';

  ## Location config -- since Germany is my 127.0.0.1
  time.timeZone = mkDefault "Europe/Berlin";
  i18n.defaultLocale = mkDefault "en_US.UTF-8";

  # So the vaultwarden CLI knows where to find my server.
  modules.shell.vaultwarden.config.server = "vault.lissner.net";
}
