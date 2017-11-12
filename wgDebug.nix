{ stdenv, writeScriptBin }:

writeScriptBin "wgDebug" ''
    #!${stdenv.shell}

    # Small script that cats the /etc/resolv.conf file to /tmp/resolv.boot
    printf 'cat /etc/resolv.conf\n' > "/tmp/wginfo.txt"
    cat "/etc/resolv.conf" > "/tmp/wginfo.txt"
    printf '\n\n\n' > "/tmp/wginfo.txt"
    printf 'cat /etc/nsswitch\n' > "/tmp/wginfo.txt"
    cat "/etc/nsswitch.conf" > "/tmp/wginfo.txt"
    printf '\n\n\n' > "/tmp/wginfo.txt"
    printf 'cat /etc/host.conf\n' > "/tmp/wginfo.txt"
    cat "/etc/host.conf" > "/tmp/wginfo.txt"
    printf '\n\n\n' > "/tmp/wginfo.txt"
    printf 'journalctl -b -u wireguard-wg_home\n' > "/tmp/wginfo.txt"
    journalctl -b -u wireguard-wg_home > "/tmp/wginfo.txt"
''
