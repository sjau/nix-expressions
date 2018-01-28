{ stdenv, writeScriptBin, nix-info }:

writeScriptBin "getTechDetails" ''
    #!${stdenv.shell}

    # Small script to download
    cd "/home/hyper/Syncthing/Music" && youtube-dl -x "$1"
''
