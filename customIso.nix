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

#    services.xserver = {
#        enable = true;
#        layout = "ch";
#        xkbOptions = "eurosign:e";
#        # Automatically login as root.
#        displayManager.slim = {
#            enable = true;
#            defaultUser = "root";
#            autoLogin = true;
#        };
#        desktopManager.plasma5 = {
#            enable = true;
#            enableQt4Support = false;
#        };
#        # Enable touchpad support for many laptops.
#        synaptics.enable = true;
#    };

    # Use KDE5 unstable
#    nixpkgs.config.packageOverrides = super: let self = super.pkgs; in {
#          plasma5_stable = self.plasma5_latest;
#        kdeApps_stable = self.kdeApps_latest;
#    };

    # KDE complains if power management is disabled (to be precise, if
    # there is no power management backend such as upower).
#    powerManagement.enable = true;


    # Start the X server by default.
#    services.xserver.autorun = false;

    # Provide networkmanager for easy wireless configuration.
    networking.networkmanager.enable = true;
    networking.wireless.enable = false;


    # Time.
    time.timeZone = "Europe/Zurich";

    # State Version - mostly for bases
    system.stateVersion = "20.03";
#    system.activationScripts.installerDesktop = let
#        desktopFile = pkgs.writeText "nixos-manual.desktop" ''
#        [Desktop Entry]
#        Version=1.0
#        Type=Application
#        Name=NixOS Manual
#        Exec=firefox ${config.system.build.manual.manual}/share/doc/nixos/index.html
#        Icon=text-html
#        '';
#    in ''
#        mkdir -p /root/Desktop
#        ln -sfT ${desktopFile} /root/Desktop/nixos-manual.desktop
#        ln -sfT ${pkgs.konsole}/share/applications/org.kde.konsole.desktop /root/Desktop/org.kde.konsole.desktop
#        ln -sfT ${pkgs.gparted}/share/applications/gparted.desktop /root/Desktop/gparted.desktop
#    '';

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
