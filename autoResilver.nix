{ stdenv, writeScriptBin }:

writeScriptBin "autoResilver" ''
    #!${stdenv.shell}

    poolName="tank"

    devices[0]="usb-TOSHIBA_External_USB_3.0_20170612010552F-0:0"
    devices[1]="usb-TOSHIBA_External_USB_3.0_2012110725463-0:0"

    for i in "${devices[@]}"; do
        poolStatus=$(zpool status | grep "${i}")
        if [[ -b "/dev/disk/by-id/${i}" && ( "${poolStatus}" == *"UNAVAIL"* || "${poolStatus}" == *"OFFLINE"* ) ]]; then
            # Device exists on the system, but is not in zpool; set it to online
            zpool online "${poolName}" "/dev/disk/by-id/${i}"
        fi
    done
''
