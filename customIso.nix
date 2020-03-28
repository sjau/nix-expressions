{config, pkgs, ...}:
{
    imports = [
        <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-base.nix>
        # Provide an initial copy of the NixOS channel so that the user
        # doesn't need to run "nix-channel --update" first.
        <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
        ./customIsoFiles/files.nix
    ];

    # Grub also needs zfs
    boot.loader.grub.zfsSupport = true;

    # Enable ZFS (unstable needed for native zfs encryption)
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.enableUnstable = true;

    # Select internationalisation properties.
    console.font = "Lat2-Terminus16";
    console.keyMap = "sg-latin1";    # Swiss German keyboard layout
    i18n.defaultLocale = "de_CH.UTF-8";

    # Provide networkmanager for easy wireless configuration.
    networking.networkmanager.enable = true;
    networking.wireless.enable = false;


    # Time.
    time.timeZone = "Europe/Zurich";

    # State Version - mostly for bases
    system.stateVersion = "20.09";

    environment.files.root = {
      root = "/root";
      files = {
        ".tmux.conf".source = "${./customIsoFiles/tmux.conf}";
        "min_conf.nix".source = "${./customIsoFiles/min_conf.nix}";
        "installZFS" = {
            mode = "a+rwx";
            user = "root";
            source = "${./customIsoFiles/installZFS}";
        };
        ".fullInstall" = {
            mode = "a+rwx";
            user = "root";
            source = "${./customIsoFiles/fullInstall}";
        };
      };
    };

    # List of packages that gets installed....
    environment.systemPackages = with pkgs; [
        cryptsetup
        htop
#        kate
#        gparted
        rsync
        tmux
    ];
}
