{ stdenv, writeScriptBin }:

writeScriptBin "checkVersion" ''
    #!${stdenv.shell}

    # Small script to check package version in given nix channel
    getChannel() {
        curYear=$(date +"%y")
        curMonth=$(date +"%-m")
        lastYear=$((curYear - 1))
        if [[ $curMonth -ge 9 ]]; then
            n1="nixos-$curYear.09"
            n2="nixos-$curYear.03"
        elif [[ $curMonth -ge 3 ]]; then
            n1="nixos-$curYear.03"
            n2="nixos-$lastYear.09"
        else
            n1="nixos-$lastYear.09"
            n2="nixos-$lastYear.03"
        fi
        printf "%s\n\n  %s\n  %s\n  %s\n  %s\n" "Select the desired channel:" "(1) nixos-unstable-small" "(2) nixos-unstable" "(3) $n1" "(4) $n2"
        read -r -e -p "Enter 1-4 for the channel to search: " -i "" channelNumber
        
        case "$channelNumber" in
            1)  channelName="nixos-unstable-small"
                ;;
            2)  channelName="nixos-unstable"
                ;;
            3)  channelName="$n1"
                ;;
            4)  channelName="$n2"
                    ;;
        esac
    }
    
    getPackage() {
        read -r -e -p "Enter the package name that you want to search, e.g. chromium: " -i "" packageName
    }

    getChannel
    getPackage

    nix eval -f channel:$channelName $packageName.name
''
