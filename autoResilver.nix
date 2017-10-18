{ stdenv, writeScriptBin }:

writeScriptBin "autoResilver" ''
    #!${stdenv.shell}

    # Small script to auto-resilver devices that belong to pool
    # Usage: autoResilver "pool name" "device id"
    # You could add a system cron job like
    #     "*/5 * * * autoResilver 'tank' 'usb-TOSHIBA_External_USB_3.0_20170612010552F-0:0'"

    poolName="$1"
    device="$2"

    poolStatus=$(zpool status | grep "$i")
    if [[ -b "/dev/disk/by-id/$i" && ( "$poolStatus" == *"UNAVAIL"* || "$poolStatus" == *"OFFLINE"* ) ]]; then
        # Device exists on the system, but is not in zpool; set it to online
        zpool online "$poolName" "/dev/disk/by-id/$i"
    fi
''
