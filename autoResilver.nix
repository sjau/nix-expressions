{ stdenv, writeScriptBin }:

writeScriptBin "autoResilver" ''
    #!${stdenv.shell}

    # Small script to auto-resilver devices that belong to pool
    # Usage: autoResilver "pool name" "device1 device2 device3"
    # You could add a system cron job like
    #     "*/5 * * * root autoResilver 'tank' 'usb-TOSHIBA_External_USB_3.0_20170612010552F-0:0 usb-TOSHIBA_External_USB_3.0_2012110725463-0:0'"

    poolName="$1"
    read -r -a device <<<"$2"

    for i in "$device[@]"; do
        poolStatus=$(zpool status | grep "$i")
        if [[ -b "/dev/disk/by-id/$i" && ( "$poolStatus" == *"UNAVAIL"* || "$poolStatus" == *"OFFLINE"* ) ]]; then
            # Device exists on the system, but is not in zpool; set it to online
            zpool online "$poolName" "/dev/disk/by-id/$i"
        fi
    done
''
