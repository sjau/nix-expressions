{ stdenv, writeScriptBin }:

writeScriptBin "wgRouteAdd" ''
    #!${stdenv.shell}

    # Reset /tmp/wgRouteAdd.txt
    printf "%s" "" > "/tmp/wgRouteAdd.txt"

    # Param1 is domain of wg server with or without port; filtering needed
    wgServer="''${1%%.*}"
    wgAddr=$(getent ''${wgServer})
    wgAddr="''${remoteIP% *}"
    printf "%s\n" "''${wgAddr}" > "/tmp/wgRouteAdd.txt"

    # Figure out current routing
    while IFS= read a b c d e f; do
        if [[ $a == "default" && $b == "via"]]; then
            #ip route add 81.6.36.24/32 via 10.0.2.0 dev ens3
            printf "%s\n" "ip route add ''${wgAddr}/32 via ''${c} dev ''${e}" >> "/tmp/wgRouteAdd.txt"
        done
    done < $(ip addr list)
''
