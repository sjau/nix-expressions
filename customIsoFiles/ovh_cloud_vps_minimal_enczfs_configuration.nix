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
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDAdnlsZ9itmyRQyvOtzTjLUFLXBD2nv5+GHKH7SjAVijL+bRE/+rcQYiAzsex7RDC/RxAf1scX1AvHzdrvlDSL/0BTC9/QEhU88yhR1tZMyN9bteIeR79SGPpSIq2Q+uJ2J4/OPenDs2wJSRUKUsBpWQvqkBw2PSL430fOAQ0/ndNgFtzFRTHs/sEAB1qjnVljbSRWGsh5H7uHqvmH9vPSfN1eDp8HMQTCvOkT7qAfkHG4rtjMvhe50RiOW0DvG6mlcvkkXJaxHoc2mhP9ufdzdSx8esZaxthxzyPq4uH/zA209sUrH8VgeOEVixeJaB6AgAW/TIvhZ24ps8zoGMkZIMDzhWkdOTBMAjEy8lkglPjhaLWcQD1daZQzynPPb5/uLcSr9YfOpPBTHoXldpylrrcdDGbQEVTmNZarO9oaZmM+kFnMmQQGt8qCCJao/1C9gsdc/ZgDOKN3y22HSNtrSAXrvbEyLxPGOoot60pMFSaJOM+xMSi6zuVz3wWXSbtrC/mATBURxEhwcsCCaTqzWYvrsOQTPtbbRwvbvedn0iEzRHFvfM+goupWlhx5YEl88T05nz4r3o4h106uFivxfZyJrybiFpRFhNtwO7qVw6V3pe8kegPhvrX9ZyKtyS8FSubNS1Ek2zR7kVjpKQKQ7h+Cn9YuhQNHHgYM1LCIVw== root@servi-nixos"
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDozT/ErRrIheum+rVNQtX9VX/1WSPP3Kg4aMhvZfEX5Us37iddGVz8dWM+K7W4lSc998aR/j1QexR6TgfgFp8P8vtLusn4gz46Jbq7Z5q28+OWqRkTTRC73xB3PxTmRrBdef/K2BHQLtcVeB2zsiEvN1T+AwRbs6SI2DXEyfaq617EgqItQHq4ZBrcUpfJdHROP52VpCt7g9Y0c2DahzpY4nFgjoKv+jB4i0a9vvBFJfN9p2BXpc/xUdavf387yvTO2fxDLkQe0BNgQL0ngVWVtjrne4MVbwJbtdTh7W8hFJIGy5nmJt7kmkKWFHFXvABgZzusS97L5bdA3K2GfftBs0ZD2rCXRDZeBKxPqPPaL+ZQbpixWLnJ44DjEg4RaBVbyYbi+Cmm4qyYGxbupuPtLW9f2L1IG5yG26wJ/MUQtREj+qjN6vAaEvEDEiBLnoVyQegOZDiH6KUqgql9PK9WcVOOdrQmJtp5txFdyxS3+Y5UtU+1lMiPMi5PFO6g7o+SXdlEGbtQbOvYjUeMsdT0+fF9fisKTAvt8xJ2jFXJjedeXduLyYpn8nNT4IJG5EEKUgDQqjoszGZffyHkMepwHA6ZJBQeyOMFb1YvSjCL9DLEzxV4p5t7uHs1JjzT7M8zguo7fvFmHtiuFJ+GacWyfnCIfVx2+V11gtFQD2VYNw== hyper@subi"
                "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3gyhngW3brbYEe+OTYqHlxQa3EhqqH4IN+iCcH8PPDw3pj+mrdMTiTYFsfKxz/q2GCpQmNSue/rmm51FjQGkAXTpvfvVDJ2cHK5e5t//1bnGxFj8lym/MQEQ4WgVbx9RSqU4iBQneXG4yhDBAD2sntrcF9vyOJNGg77Io5j807xjmsdK7vmNkbglREwkPaNQtKULbMCS2jE3UIQ09JOUioNSsYE5Q0kB8rTFVX42XZ4imdYh6rSiJxBF4eocXE4TBmiTLuSUOiI6vm0AuQjsSqfMSTBIQVkaYWdsjA4EDpCoeu+CmXf8l2ijhh/y1DsSz3NrlPB6qza5lviduAAqjtDVpOUrjDqcHaMkCCQGi8z0tlPAqlKJp0Fx2J5PR5J/4OuFARgOGaIm9Hi1KEcGV85J/59y/DNX1aj9A4WpUxJuvj8C7XiNB/nW2REpW3cp0uL/G0HO1sj3ujeFkJO02Jxr8Y+oYwzdLUw3jQhI4oIHqW2RO9zeKHmewzljrf0tPr9aFcJGyj/vhB8vDJS7WD8+k9ygi47NbTJ/PjkHssRWXwIRLBc5ieQvm+SlwL1/R+Aq1rdeKyNtf5BEDsnvYzaTUrQmGgCyOFb3OsrU0WC+LS3UK4+xNAhiAc3SyW/J5yRAIBHGBTY1dij4jV3kAxP51UgNJFuXyrKJIK4yGqQ== hyper@servi"
             ];
        };
        postCommands = ''
            echo "zfs load-key -a; killall zfs" >> /root/.profile
        '';
    };
    boot.initrd.kernelModules = [ "virtio_pci" ];

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
        set constantshow
        # include /usr/share/nano/sh.nanorc
    '';

    # The NixOS release to be compatible with for stateful data such as databases.
    system.stateVersion = "19.03";

    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
        cryptsetup
        curl
        git
        htop
        tmux
        mc
    ];
}
