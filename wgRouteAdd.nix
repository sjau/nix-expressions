{ stdenv, writeScriptBin }:

writeScriptBin "wgRouteAdd" ''
    #!${stdenv.shell}

    # Reset /tmp/wgRouteAdd.txt
    printf "%s" "" > "/tmp/wgRouteAdd.txt"

    # Param1 is domain of wg server with or without port; filtering needed
    wgServer="''${1%%.*}"
    wgAddr=$(getent hosts "''${wgServer}")
    wgAddr="''${wgAddr%% *}"
    printf "%s\n" "''${wgAddr}" > "/tmp/wgRouteAdd.txt"

    # Figure out current routing
    while read -r destination gateway genmask flags metric ref use iface; do
        if [[ $flags == "UG"*  ]]; then
            #ip route add REMOTE IP/32 via LOCAL GATEWAY dev INTERFACE
            printf "%s\n" "ip route add ''${wgAddr}/32 via ''${gateway} dev ''${iface}" >> "/tmp/wgRouteAdd.txt"
        fi
    done < <(route -n)
    
    # Push Nameserver, if provided
    # Param2 = new namserver
    # Param3 = wg interface name
    if [[ ! -z $2 && ! -z $3 ]]; then
        #printf "nameserver ''${newNS}" | resolvconf -a ''${3} -m 0
        printf "%s\n" "printf \"nameserver ''${newNS}\" | resolvconf -a ''${3} -m 0" >> "/tmp/wgRouteAdd.txt"
    fi
''
