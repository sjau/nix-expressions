{
  imports = [
    ./configuration.nix
  ];

  # Use zfs unstable for encryption
  boot.zfs.enableUnstable = true;

  # Set keyboard layout
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "sg-latin1";
    defaultLocale = "en_US.UTF-8";
  };


  # Make it use predictable interface names starting with eth0
  boot.kernelParams = [ "net.ifnames=0" ];
  networking = {
    # Use google's public DNS server
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    useDHCP = true;
  };
  kexec.autoReboot = false;
  users.users.root.initialPassword = SET PASSWORD;
}
