{ stdenv, writeScriptBin }:

writeScriptBin "checkVersion" ''
    #!${stdenv.shell}

    # Small script to check package version in given nix channel
    getChannel() {
        n=1
        while read -r line; do
        # Check if the line contains the substring "nixos-"
        if [[ $line = *"nixos-"* ]]; then
                # Cut everything after "</a>"
                curStr="''${line%%</a>*}"
                # Cut everything before the last ">"
                curStr="''${curStr##*>}"
                printf "  %s: %s\n" "$n" "$curStr"
                # Build array to reference the correct string after selection
                releaseArr[$n]="$curStr"
                ((n++))
            fi
        done < <(curl -s https://nixos.org/channels/)

        read -r -e -p "Enter 1-$n for the channel to search: " -i "" channelNumber
        channelName=''${releaseArr[$channelNumber]}
    }
    
    getPackage() {
        read -r -e -p "Enter the package name that you want to search, e.g. chromium: " -i "" packageName
    }

    getChannel
    getPackage

    nix eval -f channel:$channelName $packageName.name
''

