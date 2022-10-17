# 1. Setup onedrive
#
# $ onedrive --confdir=$HOME/.config/onedrive-0
# This will start the authentication process in the browser. You then need to copy
# the final url in the browser tab an post it in the terminal.
#
# $ systemctl --user enable onedrive@onedrive-0.service
# $ systemctl --user start onedrive@onedrive-0.service
#
# 2. Then check:
# $ systemctl --user status onedrive@onedrive-0.service
# $ journalctl --user -t onedrive | less
{ options, config, lib, ... }:

with lib;
with lib.my;
let cfg = config.modules.services.onedrive;
in {
  options.modules.services.onedrive = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    services.onedrive = {
      enable = true;
    };
  };
}
