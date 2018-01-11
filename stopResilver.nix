{ stdenv, writeScriptBin }:

writeScriptBin "stopResilver" ''
    #!${stdenv.shell}

    # Small script to stop auto-resilver/mirroring devices that belong to the pool
    # Usage: stopResilver "pool name" "device1 device2 device3"
    # Best to use it with a systemd unit file that runs before shutdown.
    # Setting the external devices to "OFFLINE" causes faster re-silvering (maybe)

    poolName="$1"
    IFS=', ' read -r -a devices <<< "$2"

    for i in ''${devices[@]}; do
        poolStatus=$(zpool status | grep "$i")
        if [[ -b "/dev/disk/by-id/$i" && "$poolStatus" == *"ONLINE"* ]]; then
            # Device exists on the system and is in zpool; set it to offline
            zpool offline "$poolName" "$i"
        fi
    done
''
