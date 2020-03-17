{ stdenv, writeScriptBin }:

writeScriptBin "stopResilver" ''
    #!${stdenv.shell}

    # This script sets the mirrored devices to "OFFLINE" status.
    # It checks whether devices are still being resilvered/scrubbed, if so
    # then it won't offline them.
    # It's an improvement over the stopResilver script at that didn't work
    # well with systemd unit file on shutdown - most of the time the mirror
    # just became degraded.
    # Usage: offlineResilver "pool name" "device1 device2 device3"
    # Best it with cron

    poolName="$1"
    IFS=', ' read -r -a devices <<< "$2"

    for i in ''${devices[@]}; do
        poolStatus=$(zpool status)
        # Check if pool is being resilvered, if so, exit
        [[ "$poolStatus" == *"currently being resilvered"* ]] && exit 0
        # Check if pool is being scrubbed, if so, exit
        [[ "$poolStatus" == *"scrub in progress"* ]] && exit 0
        # Check if device exists, if so, set it offline
        if [[ -b "/dev/disk/by-id/$i" ]] && zpool offline "$poolName" "$i"
        fi
    done
''
