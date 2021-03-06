{ stdenv, writeScriptBin }:

writeScriptBin "autoResilver" ''
    #!${stdenv.shell}

    # Small script to auto-resilver devices that belong to pool
    # Usage: autoResilver "pool name" "device1 device2 device3"
    # You could add a system cron job like
    #     "*/5 * * * * root autoResilver 'tank' 'usb-TOSHIBA_External_USB_3.0_20170612010552F-0:0, usb-TOSHIBA_External_USB_3.0_2012110725463-0:0'"

    poolName="$1"
    lockDir="/var/tmp"
    IFS=', ' read -r -a devices <<< "$2"

    for i in ''${devices[@]}; do
        poolStatus=$(zpool status | grep "$i")
        curDate=$(date '+%Y-%m-%d')
        if [[ -b "/dev/disk/by-id/$i" && ( "$poolStatus" == *"UNAVAIL"* || "$poolStatus" == *"OFFLINE"* ) ]]; then
            # Check if there is a lockfile for this day to ensure it only happens once a day
            if [[ ! -f "$lockDir/autoResilver-$i" ]] && [[ ! -f "$lockDir/autoResilver-$curDate-$i" ]]; then
                # Device exists on the system, but is not in zpool and no lockfile; set it to online and create lockfile
                zpool online "$poolName" "/dev/disk/by-id/$i" && touch "$lockDir/autoResilver-$i" && touch "$lockDir/autoResilver-$curDate-$i"
            else
            # Check if file modification was more than 24h ago and delete it, if so, delete lock files
                for f in "$lockDir/autoResilver"*; do
                    (($(date +"%s") - $(stat -c "%Y" "$f") > 86400)) && rm "$f"
                done
            fi
        fi
    done
''
