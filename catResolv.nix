{ stdenv, writeScriptBin }:

writeScriptBin "catResolv" ''
    #!${stdenv.shell}

    # Small script that cats the /etc/resolv.conf file to /tmp/resolv.boot
    cat "/etc/resolv.conf" > "/tmp/resolv.boot"
    cat "/etc/nsswitch.conf" > "/tmp/nsswitch.boot"
    cat "/etc/host.conf" > "/tmp/host.boot"
''
