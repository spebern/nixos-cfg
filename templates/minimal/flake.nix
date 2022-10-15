{
  description = "A grossly incandescent nixos config.";

  inputs = {
    dotfiles.url = "github:spebern/nixos-cfg";
  };

  outputs = inputs @ { dotfiles, ... }: {
    nixosConfigurations = dotfiles.lib.mapHosts ./hosts {
      imports = [
        # If this is a linode machine
        # "${dotfiles}/hosts/linode.nix"
      ];
    };
  };
}
