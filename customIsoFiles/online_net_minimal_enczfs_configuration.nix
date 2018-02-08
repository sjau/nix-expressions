{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
        ./hardware-configuration.nix
        ];

    # Add more filesystems
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.enableUnstable = true;

    # Use the GRUB 2 boot loader.
    boot.loader.grub.enable = true;
    boot.loader.grub.version = 2;
    boot.loader.grub.zfsSupport = true;
    boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

    boot.kernelParams = [ "net.ifnames=0" ];

    boot.initrd.network = {
        enable = true;
        ssh = {
            enable = true;
            port = 2222;
            hostECDSAKey = /root/.nixos/initrd-ssh-key;
            authorizedKeys = [
                ADD REAL KEYS
             ];
        };
        postCommands = ''
            echo "zfs load-key -a; killall zfs" >> /root/.profile
        '';
    };
    boot.initrd.kernelModules = [ "igb" ];

    # Trust hydra. Needed for one-click installations.
    nix.trustedBinaryCaches = [ "http://hydra.nixos.org" ];

    # Setup networking
    networking = {
        hostName = "freshNixos"; # Define your hostname.
        hostId = "bac8c473";
        #  enable = true;  # Enables wireless. Disable when using network manager
        useDHCP = true;
    };

    # Select internationalisation properties.
    i18n = {
        consoleFont = "Lat2-Terminus16";
        consoleKeyMap = "sg-latin1";
        defaultLocale = "en_US.UTF-8";
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
        enable = true;
        permitRootLogin = "yes";
    };

    # Enable ntp or rather timesyncd
    services.timesyncd = {
        enable = true;
        servers = [ "0.ch.pool.ntp.org" "1.ch.pool.ntp.org" "2.ch.pool.ntp.org" "3.ch.pool.ntp.org" ];
    };

    # Time.
    time.timeZone = "Europe/Zurich";

    # Add the NixOS Manual on virtual console 8
    services.nixosManual.showManual = true;

    # Setup nano
    programs.nano.nanorc = ''
        set nowrap
        set tabstospaces
        set tabsize 4
        set const
        # include /usr/share/nano/sh.nanorc
    '';

    # The NixOS release to be compatible with for stateful data such as databases.
    system.stateVersion = "18.03";

    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
        cryptsetup
        curl
        git
        htop
        tmux
    ];
}
