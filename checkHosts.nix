{ stdenv, writeScriptBin, nmap }:

writeScriptBin "checkHosts" ''
    #!${stdenv.shell}

    # Small script to check connected devices on the subnet
    getSubnet() {
        read -r -e -p "Enter your subnet to check, e.g. 192.168.0: " -i "10.0.0" checkSubnet
    }

    getSubnet

    nmap -sP ''${checkSubnet}.0/24
''

